'use-strict'

const functions = require('firebase-functions');
const admin     = require('firebase-admin');


exports.companyVerifiedCourses = functions.firestore
.document("verifiedCourses/{userUid}/userCourses/{courseId}")
.onWrite(async (snapshot, context) => {


    if(snapshot.empty){
        console.log("empty snapshot expert verified courses");
        return null;
    }
        ///This will check if the document is not empty
        const previousData = snapshot.before.data();
        const nextData = snapshot.after.data();
        var timestamp = admin.firestore.Timestamp.now().toMillis;

        //const fetchDocument = admin.firestore().collection('verifiedCourses').doc(context.params.userUid).collection("userCourses").doc(context.params.courseId);

        ///This is for getting the id of the course company

        const courseCompanyOwnerIDDocument = await admin.firestore().collection('verifiedCourses').doc(context.params.userUid).collection("userCourses").doc(context.params.courseId).get();
        const courseCompanyOwnerID = courseCompanyOwnerIDDocument.data().cuid;
            console.log(courseCompanyOwnerID);

        //This will get the sparks course handler uid, company name and last name


        const getCourseCompanyOwnerUid = await admin.firestore().collection('courseCompany').doc(courseCompanyOwnerID).get();
         const courseCompanyOwnerUid = getCourseCompanyOwnerUid.data().uid;
         const courseCompanyOwnerName = getCourseCompanyOwnerUid.data().name;
         const courseCompanyOwnerLastName = getCourseCompanyOwnerUid.data().ln;


         //This will get the token of the course company
         const courseCompanyOwnerTokenIDDocument = await admin.firestore().collection('users').doc(courseCompanyOwnerUid).get();
         const courseCompanyOwnerTokenID = courseCompanyOwnerTokenIDDocument.data().tkn;

      
 //Get the fullname of the content creator.
 const fullnameDocument = await admin.firestore().collection('users').doc(context.params.userUid).collection('Personal').doc('personalInfo').get();
 const fullname = fullnameDocument.data().nm;
 const courseCompanyOwnerPix = fullnameDocument.data().pimg;


//Get the first and last name of the content creator.

const firstName = fullname.fn;
const lastName = fullname.ln;

//Get the name of the course and topic
const fetchCourseDetails = await admin.firestore().collection('verifiedCourses').doc(context.params.userUid).collection("userCourses").doc(context.params.courseId).get();

const courseName = fetchCourseDetails.data().name;
const courseTopic = fetchCourseDetails.data().topic;
const courseId = fetchCourseDetails.data().vi_id;

console.log(courseTopic);
  //Title of FCM notification
  const notificationTitle = "Course verification"+ " " +courseCompanyOwnerName;

        //notification message

        const notificationMessage = courseCompanyOwnerLastName +" "+ "a course have been verified by your company"+" "+ courseTopic;



            //create notification object

            var payLoad = {
                notification: {
                    title: notificationTitle,
                    body: notificationMessage,
                },

               data:{
                acct: "Personal",
                notificationType: "companyVerifiedCourses",
                 name:courseName,
                 topic:courseTopic,
                 fn:firstName,
                 ln:lastName,
                 pimg:courseCompanyOwnerPix,
                 courseId:courseId,
                 click_action: "FLUTTER_NOTIFICATION_CLICK",

               },
               token: courseCompanyOwnerTokenID,

              
            }
            
//Create a notification message inside the notification collection for classroom
await admin.firestore().runTransaction(async (transaction) => {
    const createNotificationDoc = admin.firestore().collection("classroomNotification").doc();
    transaction.set(createNotificationDoc, {
        msg: notificationMessage,
        uid: [courseCompanyOwnerUid],
        seen: 'unread',
        doc: createNotificationDoc.id,
        ts: timestamp,
        
    });

});

            try{ 
                admin.messaging().send(payLoad).then((response) => {
                console.log('content company Sent successfully');
                console.log(courseCompanyOwnerTokenID);
                console.log(response);
                return null;

            }).catch((error) => {
                console.log("Error sending message content company:", error);
                return null;
            });

        }catch(e){
            console.log('Not successful company verified courses');
            console.log(e);
            return null;
    
        }
       
   
});
