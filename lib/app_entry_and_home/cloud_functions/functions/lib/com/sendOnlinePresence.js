'use-strict'

const functions = require('firebase-functions');
const admin     = require('firebase-admin');

exports.sendOnlinePresence = functions.database
    .ref('/status/{userId}')
    .onUpdate((event, context) => {

        var db = admin.firestore();
        
        const userId  = context.params.userId;

        //var fieldValue = admin.firestore.FieldValue;

        var timestamp = admin.firestore.Timestamp.now().toMillis();

        const usersRef = db.collection("users");

        var snapShot = event.after;

        return snapShot.ref.once('value')

        .then(statusSnap => {

            return snapShot.val();
            
        })
        .then(status => {
            
            console.log("Status: " + status + " at " + timestamp.toString());
            
            if (status === 'offline'){

                console.log("Status Offline. Disconnection detected. User is online, changing to offline now.");

                usersRef
                .doc(userId)
                .set(
                        {
                            iTyg: false,
                            chW: null,
                            ol: false,
                            la: timestamp // fieldValue.serverTimestamp() //Date.now()
                        }, {merge: true}
                    );

            }
            else if (status === 'online') {

                console.log("Status Online. Disconnection detected. User is already offline.");

            }

            return null;

        })
});




