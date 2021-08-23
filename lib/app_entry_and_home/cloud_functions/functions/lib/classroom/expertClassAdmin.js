'use-strict'

const functions = require('firebase-functions');
const admin     = require('firebase-admin');


exports.expertClassAdmin = functions.firestore
.document("verifiedClasses/{userUid}/expertClasses/{classId}")
.onCreate(async (snapshot, context) => {

        ///This will check if the document is not empty
        if(snapshot.empty){
            console.log("empty snapshot expert handler");
            return null;
        }
		const newData = snapshot.data();
        var timestamp = admin.firestore.Timestamp.now().toMillis;

        //Get the name of the course and topic

const classTopic = newData.topic;
const classAdminFirstName = newData.afn;
const classAdminLastName = newData.aln;

const classPix = newData.epix;
const classCompanyPix = newData.cpix;

const classCmpanyName = newData.cna;
const expertName = newData.efn;

        //Title of FCM notification
        const notificationTitle = "Class uploaded";
  ///This is for getting the id of the class admin


///This is for getting the token id of the company
const classOwnerTokenIDDocument = await admin.firestore().collection('users').doc(newData.aid).get();
const classOwnerTokenID = classOwnerTokenIDDocument.data().tkn;
console.log("handler token", classOwnerTokenID);




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
                    notificationType: "expertClassAdmin",
                     name:classCmpanyName,
                     topic:classTopic,
                     pix:classPix,
                     companyPix:classCompanyPix,
                     classId:newData.id,
                     click_action: "FLUTTER_NOTIFICATION_CLICK",

                   },
               
              
            };

//Create a notification message inside the notification collection for classroom
await admin.firestore().runTransaction(async (transaction) => {
    const createNotificationDoc = admin.firestore().collection("classroomNotification").doc();
    transaction.set(createNotificationDoc, {
        msg: notificationMessage,
        uid: [newData.aid],
        seen: 'unread',
        doc: createNotificationDoc.id,
        ts: timestamp,
        
    });

});


            try{
  
                await admin.messaging().sendToDevice(classOwnerTokenID,payLoad)
                .then((response) => {
                console.log('content admin Sent successfully');
                console.log(classOwnerTokenID);
                console.log(response);
                return null;

            }).catch((error) => {
                console.log("Error sending message content adminr:", error);
                return null;
            });
           

    
    }catch(e){
        console.log('Not successful class admin');
        console.log(e);
        return null;

    }
});
