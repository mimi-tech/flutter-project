'use-strict'

const functions = require('firebase-functions');
const admin     = require('firebase-admin');


exports.allFriendsCourses = functions.firestore
.document("verifiedCourses/{userUid}/userCourses/{courseId}")
.onCreate(async (snapshot, context) => {

        ///This will check if the document is not empty
        if(snapshot.empty){
            console.log("empty snapshot expert handler");
            return null;
        }
		const newData = snapshot.data();
        var tokens = [];
        //Get the name of the course and topic
        const courseName = newData.name;
        const courseTopic = newData.topic;


const courseFirstName = newData.fn;
const courseLastName = newData.ln;

const coursePix = newData.pix;


        //Title of FCM notification
        const notificationTitle = "Course uploaded";
  ///This is for getting the id of the class admin


///This is for getting the token id of friends
const classFriendsTokenIDDocument = await admin.firestore().collection('users').get();
for(var token of classFriendsTokenIDDocument.docs){
    tokens.push(token.data().tkn);
}


//notification message

const notificationMessage = courseFirstName + " " + courseLastName + " " +"uploaded a course on" + " "  + "["+ courseTopic +"]";

          

            //create notification object

            var payLoad = {
                notification: {
                    title: notificationTitle,
                    body: notificationMessage,
                },
                //token: classOwnerTokenID,
                data:{
                    acct: "Personal",
                    notificationType: "allFriendsCourse",
                     name:courseName,
                     topic:courseTopic,
                     pix:coursePix,
                     courseId:newData.vi_id,
                     click_action: "FLUTTER_NOTIFICATION_CLICK",

                   },
               
              
            };
            try{
  
                await admin.messaging().sendToDevice(tokens,payLoad)
                .then((response) => {
                console.log('All course friends Sent successfully');
                console.log(response);
                return null;

            }).catch((error) => {
                console.log("Error sending message to course friends :", error);
                return null;
            });
           

    
    }catch(e){
        console.log('Not successful course friends');
        console.log(e);
        return null;

    }
});
