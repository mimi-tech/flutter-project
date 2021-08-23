'use-strict'

const functions = require('firebase-functions');
const admin     = require('firebase-admin');

//This firebase cloud function increments the number of comments a particular post has and also sends notification to the user(owner).
exports.commentOnHomePost = functions.firestore
.document("posts/{userid}/myPost/{postid}/homeComments/{documentId}")
.onWrite(async (change, context) => {

    try {
        const previousData = change.before.data();
        const nextData = change.after.data();
        const incrementNotificationCounterDocument = admin.firestore().collection("posts").doc(context.params.userid);
        let updateNotId = "";

        //Fetch the tokenID of the user who own's this post.
        const postOwnerTokenIDDocument = await admin.firestore().collection('users').doc(context.params.userid).get();
        const postOwnerTokenID = postOwnerTokenIDDocument.data().tkn;

        //Get the common id.
        const mainPost = await admin.firestore().collection('posts').doc(context.params.userid).collection("myPost").doc(context.params.postid).get();
        const postCommonID = mainPost.data().delID;

        //Fetch all post document with a common id
        const allDocWithCommonID = await admin.firestore().collection('posts').doc(context.params.userid).collection("myPost").where('delID', '==', postCommonID);

        //Title of FCM notification
        const notificationTitle = "Sparks";

        if((previousData === undefined) && (nextData !== undefined)) {

            //Get the uid of the user who commented on this post.
            const getUidWhoCommentedOnPost = nextData.auID;

            //Get the fullname of the user who commented on this post.
            const fullnameDocument = await admin.firestore().collection('users').doc(getUidWhoCommentedOnPost).collection('Personal').doc('personalInfo').get();
            const fullname = fullnameDocument.data().nm;

            //Increment the number of comments by one
            await admin.firestore().runTransaction(async (transaction) => {
                const documentToUpdate = await transaction.get(allDocWithCommonID);

                documentToUpdate.forEach((eachDocument) => {
                    //Get the current number of comments and increment it by one.
                    const newNumberOfComments = eachDocument.data().nOfCmts + 1;

                    //Update the number of comments in this post to the current value.
                    transaction.update(eachDocument.ref, {
                        nOfCmts: newNumberOfComments
                    });
               });
            });

            //Check if the user uid who commented on this post does not match with the author's uid who made the post
            if(context.params.userid !== getUidWhoCommentedOnPost) {

                //Send notification to the owner of the post.
                const notificationMessage = fullname.ln + ' ' + fullname.fn + " commented on your post.";

                //Create the structure of the FCM message.
                const FCMMessage = {
                    "notification": {
                        "title": notificationTitle,
                        "body": notificationMessage
                    },
                    "data": {
                        "acct": "Personal",
                        "notificationType": "CommentOnPost",
                        auID: nextData["auID"],
                        postId: nextData["postID"],
                        ptOwn: context.params.userid,
                        pimg: nextData["pimg"],
                        comm: nextData["comment"],
                        nm: nextData["nm"],
                    },
                    token: postOwnerTokenID
                };

                //Create a notification message inside the notification collection
                await admin.firestore().runTransaction(async (transaction) => {
                    const createNotificationDoc = admin.firestore().collection("posts").doc(context.params.userid).collection("homePLCNotifications").doc();
                    transaction.set(createNotificationDoc, {
                        auID: nextData["auID"],
                        postId: nextData["postID"],
                        ptOwn: context.params.userid,
                        pimg: nextData["pimg"],
                        comm: nextData["comment"],
                        notTye: "comment",
                        nm: nextData["nm"],
                        notSts: "Unread",
                        notID: "",
                        cts: Date.now()
                    });

                    updateNotId = createNotificationDoc.id;
                });

                const notIDUpdate = admin.firestore().collection("posts").doc(context.params.userid).collection("homePLCNotifications").doc(updateNotId)

                await admin.firestore().runTransaction(async (transaction) => {
                    transaction.update(notIDUpdate, {
                        notID: updateNotId
                    });
                });

                //Make some changes to the newly created documents
                await admin.firestore().runTransaction(async (transaction) => {
                    //Increment the notification counter by one
                    const updateNotCounter = await transaction.get(incrementNotificationCounterDocument);

                    const notificationTracker = updateNotCounter.data().notCts + 1;

                    transaction.update(incrementNotificationCounterDocument, {
                        notCts: notificationTracker
                    });
                });

                console.log("Number of comments incremented by one");

                //Send notification
                return admin.messaging().send(FCMMessage);
            }

        }

    }
    catch(error) {
        console.log(error);
    }
    
});