'use-strict'

const functions = require('firebase-functions');
const admin     = require('firebase-admin');

//This firebase cloud function increases or decreases the number of likes a post has and also sends FCM notification to the user.
exports.likeCommentFromHome = functions.firestore
.document("posts/{userid}/myPost/{postid}/homeComments/{documentId}/commentLikes/{comLikeId}")
.onWrite(async (change, context) => {

    try {
        const previousData = change.before.data();
        const nextData = change.after.data();

        //Fetch the tokenID of the user who own's this comment.
        const postOwnerTokenIDDocument = await admin.firestore().collection('users').doc(context.params.userid).get();
        const postOwnerTokenID = postOwnerTokenIDDocument.data().tkn;

        //Get the common id.
        const mainPost = await admin.firestore().collection('posts').doc(context.params.userid).collection("myPost").doc(context.params.postid).get();
        const postCommonID = mainPost.data().delID;

        //Fetch the current uploaded document
        const allDocWithCommonID = await admin.firestore().collection('posts').doc(context.params.userid).collection("myPost").doc(context.params.postid).collection("homeComments").where('commID', '==', context.params.documentId);

        //Title of FCM notification
        const notificationTitle = "Sparks";

        if((previousData === undefined) && (nextData !== undefined)) {

            //Get the fullname of the user who liked the comment.
            const fullnameDocument = await admin.firestore().collection('users').doc(nextData.id).collection('Personal').doc('personalInfo').get();
            const fullname = fullnameDocument.data().nm;


            //Increment the number of likes by one
            await admin.firestore().runTransaction(async (transaction) => {
                const documentToUpdate = await transaction.get(allDocWithCommonID);

               documentToUpdate.forEach((eachDocument) => {
                    //Get the current number of likes and increment it by one.
                    const newNumberOfLikes = eachDocument.data().nOfLikes + 1;

                    //Update the number of likes in this post to the current value.
                    transaction.update(eachDocument.ref, {
                        nOfLikes: newNumberOfLikes
                    });
               });

            });

            //Check if the user uid who liked the post matches with the author's uid who made the comment
            if(context.params.userid === getUidWhoLikedPost) {

                //Send notification to the owner of the comment.
                const notificationMessage = "You liked your post.";

                //Create the structure of the FCM message.
//                const FCMMessage = {
//                    "notification": {
//                        "title": notificationTitle,
//                        "body": notificationMessage
//                    },
//                    token: postOwnerTokenID
//                };

//                console.log("Number of likes incremented by one");
//
//                //Send notification
//                return admin.messaging().send(FCMMessage);
            }
            else {

                //Send notification to the owner of the post.
                const notificationMessage = fullname.ln + ' ' + fullname.fn + " liked your post.";

                //Create the structure of the FCM message.
//                const FCMMessage = {
//                    "notification": {
//                        "title": notificationTitle,
//                        "body": notificationMessage
//                    },
//                    token: postOwnerTokenID
//                };
//
//                console.log("Number of likes incremented by one");
//
//                //Send notification
//                return admin.messaging().send(FCMMessage);
            }
        }
        else {

            //Get the uid of the user who disliked the comment.
            const getUidWhoDisLikedPost = previousData.id;

            //Get the fullname of the user who liked the comment.
            const fullnameDocument = await admin.firestore().collection('users').doc(getUidWhoDisLikedPost).collection('Personal').doc('personalInfo').get();
            const fullname = fullnameDocument.data().nm;

            //Decrement the number of likes by one
            await admin.firestore().runTransaction(async (transaction) => {
                const documentToUpdate = await transaction.get(allDocWithCommonID);

                documentToUpdate.forEach((eachDocument) => {
                    //Get the current number of likes and decrement it by one.
                    const newNumberOfLikes = eachDocument.data().nOfLikes - 1;

                    //Update the number of likes in this post to the current value.
                    transaction.update(eachDocument.ref, {
                        nOfLikes: newNumberOfLikes
                    });
               });

            });

            //Check if the user uid who disliked the post matches with the author's uid who made the comment
            if(context.params.userid === getUidWhoDisLikedPost) {

                //Send notification to the owner of the post.
                const notificationMessage = "You disliked your post.";

//                //Create the structure of the FCM message.
//                const FCMMessage = {
//                    "notification": {
//                        "title": notificationTitle,
//                        "body": notificationMessage
//                    },
//                    token: postOwnerTokenID
//                };
//
//                console.log("Number of likes decremented by one");
//
//                //Send notification
//                return admin.messaging().send(FCMMessage);
            }
            else {

                //Send notification to the owner of the post.
                const notificationMessage = fullname.ln + " " + fullname.fn + " disliked your post.";

                //Create the structure of the FCM message.
//                const FCMMessage = {
//                    "notification": {
//                        "title": notificationTitle,
//                        "body": notificationMessage
//                    },
//                    token: postOwnerTokenID
//                };
//
//                console.log("Number of likes decremented by one");
//
//                //Send notification
//                return admin.messaging().send(FCMMessage);

            }

        }

    }
    catch(error){
        console.log(error);
    }

});