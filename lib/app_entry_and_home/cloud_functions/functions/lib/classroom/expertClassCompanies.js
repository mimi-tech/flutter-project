'use-strict'

const functions = require('firebase-functions');
const admin     = require('firebase-admin');


exports.expertClassCompanies = functions.firestore
.document("verifiedClasses/{userUid}/expertClasses/{classId}")
.onCreate(async (snapshot, context) => {

        ///This will check if the document is not empty
        if(snapshot.empty){
            console.log("empty snapshot expert handler");
            return null;
        }

      

 ///This is for getting the id of the class company

 const classCompanyOwnerIDDocument = await admin.firestore().collection('verifiedClasses').doc(context.params.userUid).collection("expertClasses").doc(context.params.classId).get();

 const classOwnerID = classCompanyOwnerIDDocument.data().cid;
 var timestamp = admin.firestore.Timestamp.now().toMillis;



 //Title of FCM notification
 const notificationTitle = "Class uploaded";

///This is for getting the token id of the company

const classOwnerTokenIDDocument = await admin.firestore().collection('users').doc(classOwnerID).get();
const classOwnerTokenID = classOwnerTokenIDDocument.data().tkn;


//Get the name of the course and topic
const fetchClasseDetails = await admin.firestore().collection('verifiedClasses').doc(context.params.userUid).collection("expertClasses").doc(context.params.classId).get();

const classTopic = fetchClasseDetails.topic;
const classAdminFirstName = fetchClasseDetails.afn;
const classAdminLastName = fetchClasseDetails.aln;

const classPix = fetchClasseDetails.epix;
const classCompanyPix = fetchClasseDetails.cpix;

const classCmpanyName = fetchClasseDetails.cna;
const expertName = fetchClasseDetails.efn;
const expertClassid = fetchClasseDetails.id;

  //notification message

  const notificationMessage = classAdminFirstName + " " + classAdminLastName + " " +"uploaded a class on" + " " + " " + "["+ classTopic +"] for" + " "+ expertName;


            //create notification object

            var payLoad = {
                notification: {
                    title: notificationTitle,
                    body: notificationMessage,
                },
                //token: classOwnerTokenID,
                data:{
                    acct: "Personal",
                    notificationType: "expertClassCompany",
                     name:classCmpanyName,
                     topic:classTopic,
                     pix:classPix,
                     companyPix:classCompanyPix,
                     classId:expertClassid,
                     click_action: "FLUTTER_NOTIFICATION_CLICK",

                   },
               
              
            };


//Create a notification message inside the notification collection for classroom
await admin.firestore().runTransaction(async (transaction) => {
    const createNotificationDoc = admin.firestore().collection("classroomNotification").doc();
    transaction.set(createNotificationDoc, {
        msg: notificationMessage,
        uid: [classOwnerID],
        seen: 'unread',
        doc: createNotificationDoc.id,
        ts: timestamp,
        
    });

});



            try{
   
                await admin.messaging().sendToDevice(classOwnerTokenID,payLoad)
                .then((response) => {
                console.log('expert company Sent successfully');
                console.log(classOwnerTokenID);
                console.log(response);
                return null;

            }).catch((error) => {
                console.log("Error sending message expert company:", error);
                return null;
            });
           

       
    }catch(e){
        console.log('Not successful expert company');
        console.log(e);
        return null;

    }
});
