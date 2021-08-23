'use-strict'

const functions = require('firebase-functions');
const admin     = require('firebase-admin');


exports.allFriendsClass = functions.firestore
.document("verifiedClasses/{userUid}/expertClasses/{classId}")
.onCreate(async (snapshot, context) => {

        ///This will check if the document is not empty
        if(snapshot.empty){
            console.log("empty snapshot expert handler");
            return null;
        }
		const newData = snapshot.data();
        var tokens = [];
        //Get the name of the course and topic

const classTopic = newData.topic;
const classAdminFirstName = newData.efn;
const classAdminLastName = newData.eln;

const classPix = newData.epix;


        //Title of FCM notification
        const notificationTitle = "Class uploaded";
  ///This is for getting the id of the class admin


///This is for getting the token id of friends
const classFriendsTokenIDDocument = await admin.firestore().collection('users').get();
for(var token of classFriendsTokenIDDocument.docs){
    tokens.push(token.data().tkn);
}


//notification message

const notificationMessage = classAdminFirstName + " " + classAdminLastName + " " +"uploaded a class on" + " "  + "["+ classTopic +"]";

          

            //create notification object

            var payLoad = {
                notification: {
                    title: notificationTitle,
                    body: notificationMessage,
                },
                //token: classOwnerTokenID,
                data:{
                    acct: "Personal",
                    notificationType: "allFriendsClass",
                     topic:classTopic,
                     pix:classPix,
                     classId:newData.id,
                     click_action: "FLUTTER_NOTIFICATION_CLICK",

                   },
               
              
            };
            try{
  
                await admin.messaging().sendToDevice(tokens,payLoad)
                .then((response) => {
                console.log('content admin Sent successfully');
                console.log(response);
                return null;

            }).catch((error) => {
                console.log("Error sending message to expert friends :", error);
                return null;
            });
           

    
    }catch(e){
        console.log('Not successful expert friends');
        console.log(e);
        return null;

    }
});
