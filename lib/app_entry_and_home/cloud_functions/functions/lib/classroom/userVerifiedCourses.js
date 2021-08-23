'use-strict'

const functions = require('firebase-functions');
const admin     = require('firebase-admin');


exports.userVerifiedCourses = functions.firestore
.document("verifiedCourses/{userUid}/userCourses/{courseId}")
.onWrite(async (snapshot, context) => {

        ///This will check if the document is not empty
      

        if(snapshot.empty){
            console.log("empty snapshot");
            return;
        }
        ///This is for getting the token id of the content creator

        const courseOwnerTokenIDDocument = await admin.firestore().collection('users').doc(context.params.userUid).get();
        const courseOwnerTokenID = courseOwnerTokenIDDocument.data().tkn;

        var timestamp = admin.firestore.Timestamp.now().toMillis;

        //Title of FCM notification
        const notificationTitle = "Course verification";

 //Get the fullname of the content creator.
 const fullnameDocument = await admin.firestore().collection('users').doc(context.params.userUid).collection('Personal').doc('personalInfo').get();
 const fullname = fullnameDocument.data().nm;


//Get the first and last name of the content creator.

const firstName = fullname.fn;
const lastName = fullname.ln;

//Get the name of the course and topic
const fetchCourseDetails = await admin.firestore().collection('verifiedCourses').doc(context.params.userUid).collection("userCourses").doc(context.params.courseId).get();

const courseTopic = fetchCourseDetails.data().topic;
const courseName = fetchCourseDetails.data().name;
const coursePix = fetchCourseDetails.data().pix;
const courseId = fetchCourseDetails.data().vi_id;
        //notification message

        const notificationMessage ="Congratulations!" + " " +firstName +" "+ lastName + " "+ "your content " + " " + "["+ courseTopic +"]"+ " "+ "is now verified";
        
        


            //create notification object

            var payLoad = {
                notification: {
                    title: notificationTitle,
                    body: notificationMessage,
                },
                token: courseOwnerTokenID,
                data:{
                    acct: "Personal",
                    notificationType: "userVerifiedCourses",
                     name:courseName,
                     topic:courseTopic,
                     pix:coursePix,
                     courseId:courseId,
                     click_action: "FLUTTER_NOTIFICATION_CLICK",
          
                   },
               
              
            };


 //Create a notification message inside the notification collection for classroom
 await admin.firestore().runTransaction(async (transaction) => {
    const createNotificationDoc = admin.firestore().collection("classroomNotification").doc();
    transaction.set(createNotificationDoc, {
        msg: notificationMessage,
        uid: [context.params.userUid],
        pimg: fullnameDocument.data().pimg,
        fn: firstName,
        lm: lastName,
        seen: 'unread',
        doc: createNotificationDoc.id,
        ts: timestamp,
        
    });

});


            try{
   
             admin.messaging().send(payLoad)
            .then((response) => {
                console.log('content creator Sent successfully');
                console.log(courseOwnerTokenID);
                console.log(response);
                return null;

            }).catch((error) => {
                console.log("Error sending message content creator:", error);
                return null;
            });
           

    
    }catch(e){
        console.log('Not successful');
        console.log("Did not work verified courses");
        return null;

    }
});
