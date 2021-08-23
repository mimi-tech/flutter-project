'use-strict'

const functions = require('firebase-functions');
const admin     = require('firebase-admin');


exports.allFriendsUpload = functions.firestore
.document("sessionContent/{userUid}/userSessionUploads/{uploadId}")
.onCreate(async (snapshot, context) => {

        ///This will check if the document is not empty
        if(snapshot.empty){
            console.log("empty snapshot expert handler");
            return null;
        }
		const newData = snapshot.data();
        var tokens = [];
        var friendsUserIds = [];

        var timestamp = admin.firestore.Timestamp.now().toMillis;

        //Get the name of the video and topic

const uploadTopic = newData.title;
const uploadFirstName = newData.fn;
const uploadLastName = newData.ln;

const uploadPix = newData.pix;


        //Title of FCM notification
        const notificationTitle = "Video upload";
  ///This is for getting the id of the class admin


///This is for getting the token id of friends
const classFriendsTokenIDDocument = await admin.firestore().collection('users').get();
for(var token of classFriendsTokenIDDocument.docs){
    tokens.push(token.data().tkn);
    friendsUserIds.push(token.data().id);
}



//notification message

const notificationMessage = uploadFirstName + " " + uploadLastName + " " +"uploaded a video" + " "  + "["+ uploadTopic +"]";

          

            //create notification object

            var payLoad = {
                notification: {
                    title: notificationTitle,
                    body: notificationMessage,
                },
                //token: classOwnerTokenID,
                data:{
                    acct: "Personal",
                    notificationType: "allFriendsUpload",
                     topic:uploadTopic,
                     pix:uploadPix,
                     fn:uploadFirstName,
                     ln:uploadLastName,
                     uploads:newData.vi_id,
                     click_action: "FLUTTER_NOTIFICATION_CLICK",

                   },
               
              
            };

            //Create a notification message inside the notification collection for classroom
await admin.firestore().runTransaction(async (transaction) => {
    const createNotificationDoc = admin.firestore().collection("classroomNotification").doc();
    transaction.set(createNotificationDoc, {
        msg: notificationMessage,
        uid: friendsUserIds,
        seen: 'unread',
        doc: createNotificationDoc.id,
        ts: timestamp,
        
    });

});

            try{
  
                await admin.messaging().sendToDevice(tokens,payLoad)
                .then((response) => {
                console.log('upload Sent successfully');
                console.log(response);
                return null;

            }).catch((error) => {
                console.log("Error sending message to upload friends :", error);
                return null;
            });
           

    
    }catch(e){
        console.log('Not successful live friends');
        console.log(e);
        return null;

    }
});
