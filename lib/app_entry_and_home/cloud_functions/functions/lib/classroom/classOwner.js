'use-strict'

const functions = require('firebase-functions');
const admin     = require('firebase-admin');


exports.classOwner = functions.firestore
.document("verifiedClasses/{userUid}/expertClasses/{classId}")
.onCreate(async (snapshot, context) => {

        ///This will check if the document is not empty
        if(snapshot.empty){
            console.log("empty snapshot expert handler");
            return null;
        }

       

 ///This is for getting the token id of the content creator

 const newData = snapshot.data();

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

///This is for getting the token id of the class owner

const classOwnerTokenIDDocument = await admin.firestore().collection('users').doc(newData.eid).get();
const classOwnerTokenID = classOwnerTokenIDDocument.data().tkn;



var timestamp = admin.firestore.Timestamp.now().toMillis;

console.log("classowner token", classOwnerTokenID);


 //notification message

 const notificationMessage = expertName + " "+ "Your class was uploaded successfully by" + " " +classAdminFirstName + " " + classAdminLastName + " "  + "["+ classTopic +"]";



            //create notification object

            var payLoad = {
                notification: {
                    title: notificationTitle,
                    body: notificationMessage,
                },
               // token: classOwnerTokenID,
                data:{
                    acct: "Personal",
                    notificationType: "expertClassOwner",
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
        uid: [newData.eid],
        seen: 'unread',
        doc: createNotificationDoc.id,
        ts: timestamp,
        
    });

});


            try{
   
                await admin.messaging().sendToDevice(classOwnerTokenID,payLoad)
                .then((response) => {
                console.log('class owner Sent successfully');
                console.log(classOwnerTokenID);
                console.log(response);
                return null;

            }).catch((error) => {
                console.log("Error sending message class owner:", error);
                return null;
            });
           

      
    }catch(e){
        console.log('Not successful class owner');
        console.log(e);
        return null;

    }
});
