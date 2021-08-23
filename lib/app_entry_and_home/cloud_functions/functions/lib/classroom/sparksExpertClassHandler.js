'use-strict'

const functions = require('firebase-functions');
const admin     = require('firebase-admin');


exports.sparksExpertClassHandler = functions.firestore
.document("verifiedClasses/{userUid}/expertClasses/{classId}")
.onCreate(async (snapshot, context) => {

        ///This will check if the document is not empty
        if(snapshot.empty){
            console.log("empty snapshot expert handler");
            return null;
        }
        const userUid  = context.params.userUid;
        const classId = context.params.classId;
    
        var timestamp = admin.firestore.Timestamp.now().toMillis;


        //Title of FCM notification
        const notificationTitle = "Class uploaded";



  ///This is for getting the id of the expert class handler

  const classCompanyOwnerIDDocument = await admin.firestore().collection('verifiedClasses').doc(context.params.userUid).collection("expertClasses").doc(context.params.classId).get();

  const classOwnerID = classCompanyOwnerIDDocument.data().sid;


 ///This is for getting the token id of the sparks class handler

 const classOwnerTokenIDDocument = await admin.firestore().collection('users').doc(classOwnerID).get();
 const classOwnerTokenID = classOwnerTokenIDDocument.data().tkn;


//Get the name of the course and topic
const fetchClasseDetails = await admin.firestore().collection('verifiedClasses').doc(context.params.userUid).collection("expertClasses").doc(context.params.classId).get();

const classTopic = fetchClasseDetails.data().topic;
const classAdminFirstName = fetchClasseDetails.data().afn;
const classAdminLastName = fetchClasseDetails.data().aln;

const classPix = fetchClasseDetails.data().epix;
const classCompanyPix = fetchClasseDetails.data().cpix;

const classCmpanyName = fetchClasseDetails.data().cna;
const expertName = fetchClasseDetails.data().efn;
const classId = fetchCourseDetails.data().id;



        //notification message

        const notificationMessage = classAdminFirstName + " " + classAdminLastName + " " +"uploaded a class on" + " " + " " + "["+ classTopic +"] for" + " "+ expertName + " "+ classCmpanyName ;



            //create notification object

            var payLoad = {
                notification: {
                    title: notificationTitle,
                    body: notificationMessage,
                },
                //token: classOwnerTokenID,
                data:{
                    acct: "Personal",
                    notificationType: "expertClassHandler",
                     name:classCmpanyName,
                     topic:classTopic,
                     pix:classPix,
                     companyPix:classCompanyPix,
                     classId:classId,
                     click_action: "FLUTTER_NOTIFICATION_CLICK",

                   },
               
              
            };


//Create a notification message inside the notification collection for classroom
await admin.firestore().runTransaction(async (transaction) => {
    const createNotificationDoc = admin.firestore().collection("classroomNotification").doc();
    transaction.set(createNotificationDoc, {
        msg: notificationMessage,
        uid: [classOwnerID],
        cpix:classPix,
        seen: 'unread',
        doc: createNotificationDoc.id,
        ts: timestamp,
        
    });

});

            try{
   
             await admin.messaging().sendToDevice(classOwnerTokenID,payLoad)
            .then((response) => {
                console.log('class handler Sent successfully');
                console.log(classOwnerTokenID);
                console.log(response);
                return null;

            }).catch((error) => {
                console.log("Error sending message class handler:", error);
                return null;
            });
           

       
        
    }catch(e){
        console.log('Not successful class handler');
        console.log(e);
        return null;

    }
});
