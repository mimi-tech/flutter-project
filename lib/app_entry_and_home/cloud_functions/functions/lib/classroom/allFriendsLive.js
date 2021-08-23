'use-strict'

const functions = require('firebase-functions');
const admin     = require('firebase-admin');


exports.allFriendsLive = functions.firestore
.document("sessionContent/{userUid}/publishedLive/{liveId}")
.onCreate(async (snapshot, context) => {

        ///This will check if the document is not empty
        if(snapshot.empty){
            console.log("empty snapshot expert handler");
            return null;
        }
		const newData = snapshot.data();
        var tokens = [];
        //Get the name of the course and topic

const liveTopic = newData.title;
const liveFirstName = newData.fn;
const liveLastName = newData.ln;
const liveTime = newData.lt;

const livePix = newData.pix;


        //Title of FCM notification
        const notificationTitle = "Going Live";
  ///This is for getting the id of the class admin


///This is for getting the token id of friends
const classFriendsTokenIDDocument = await admin.firestore().collection('users').get();
for(var token of classFriendsTokenIDDocument.docs){
    tokens.push(token.data().tkn);
}


//notification message

const notificationMessage = liveFirstName + " " + liveLastName + " " +"will be live on"+" " + liveTime + " "  + "["+ liveTopic +"]";

          

            //create notification object

            var payLoad = {
                notification: {
                    title: notificationTitle,
                    body: notificationMessage,
                },
                //token: classOwnerTokenID,
                data:{
                    acct: "Personal",
                    notificationType: "allFriendsLive",
                     topic:liveTopic,
                     pix:livePix,
                     fn:liveFirstName,
                     ln:liveLastName,
                     liveId:newData.vi_id,
                     click_action: "FLUTTER_NOTIFICATION_CLICK",

                   },
               
              
            };
            try{
  
                await admin.messaging().sendToDevice(tokens,payLoad)
                .then((response) => {
                console.log('live Sent successfully');
                console.log(response);
                return null;

            }).catch((error) => {
                console.log("Error sending message to live friends :", error);
                return null;
            });
           

    
    }catch(e){
        console.log('Not successful live friends');
        console.log(e);
        return null;

    }
});
