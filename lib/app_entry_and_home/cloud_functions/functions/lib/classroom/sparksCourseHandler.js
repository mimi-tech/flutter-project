'use-strict'

const functions = require('firebase-functions');
const admin     = require('firebase-admin');


exports.sparksCourseHandler = functions.firestore
.document("verifiedCourses/{userUid}/userCourses/{courseId}")
.onWrite(async (snapshot, context) => {

    try{
        ///This will check if the document is not empty
        const previousData = snapshot.before.data();
        const nextData = snapshot.after.data();
        //const fetchDocument = admin.firestore().collection('verifiedCourses').doc(context.params.userUid).collection("userCourses").doc(context.params.courseId);

        ///This is for getting the id of the course company

        var timestamp = admin.firestore.Timestamp.now().toMillis;


        const courseCompanyOwnerIDDocument = await admin.firestore().collection('verifiedCourses').doc(context.params.userUid).collection("userCourses").doc(context.params.courseId).get();
        const courseCompanyOwnerID = courseCompanyOwnerIDDocument.data().cuid;
       

        //This will get the sparks course handler uid, company name and last name

         const getCourseSpHandlerOwnerUid = await admin.firestore().collection('courseCompany').doc(courseCompanyOwnerID).get();
         const courseSpHandlerOwnerUid = getCourseSpHandlerOwnerUid.data().spUid;
         const courseSpHandlerComName = getCourseSpHandlerOwnerUid.data().name;
         const courseSpHandlerLastName = getCourseSpHandlerOwnerUid.data().ln;



         //This will get the token of the sparks course handler
         const courseCompanyOwnerTokenIDDocument = await admin.firestore().collection('users').doc(courseSpHandlerOwnerUid).get();
         const courseSparksHandlerTokenID = courseCompanyOwnerTokenIDDocument.data().tkn;
 

      
 //Get the fullname of the sparks course handler.
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


  //Title of FCM notification
  const notificationTitle = "Course verification"+ " " +courseSpHandlerComName;

        //notification message

        const notificationMessage = courseSpHandlerLastName +" "+ "verified a course"+ " " + "["+ courseTopic +"]";

        if((previousData === undefined) && (nextData !== undefined)) {


            //create notification object

            var payLoad = {
                notification: {
                    title: notificationTitle,
                    body: notificationMessage,
                },
                token: courseSparksHandlerTokenID,

               data:{
                acct: "Personal",
                notificationType: "sparksCourseHandler",
                 name:courseName,
                 topic:courseTopic,
                 fn:firstName,
                 ln:lastName,
                 pimg:courseCompanyOwnerPix,
                 courseId:courseId,
                 click_action: "FLUTTER_NOTIFICATION_CLICK",

               },
              
            };


//Create a notification message inside the notification collection for classroom
await admin.firestore().runTransaction(async (transaction) => {
    const createNotificationDoc = admin.firestore().collection("classroomNotification").doc();
    transaction.set(createNotificationDoc, {
        msg: notificationMessage,
        uid: [courseSpHandlerOwnerUid],
        seen: 'unread',
        doc: createNotificationDoc.id,
        ts: timestamp,
        
    });

});


            return admin.messaging().send(payLoad) .then((response) => {
                console.log('sparks creator Sent successfully');
                console.log(courseSparksHandlerTokenID);
                console.log(response);
                return null;

            }).catch((error) => {
                console.log("Error sending message content sparks:", error);
                return null;
            });


        }else{
            console.log('I did not see any device');
            console.log(courseSparksHandlerTokenID);
           return null;

        }
    }catch(e){
        console.log('Not successful');
        console.log(e);
        return null;

    }
});
