"use-strict";

const functions = require("firebase-functions");
const admin     = require("firebase-admin");

exports.storeNewFolNotification = functions.firestore
	.document("stores/{storeId}/followers/{documentId}")
	.onCreate(async (snap, context) => {
		const newData = snap.data();

		if (newData) {
			const userName  = newData.un;

			const userId    = newData.id;

			const db        = admin.firestore();

			const storeId   = context.params.storeId;

			return db
				.collection("users")
				.doc(storeId)
				.get()
				.then(async (query) => {
					const storeToken = query.data().tkn;

					const notificationMessage = `${userName} followed your store`;

					const message = {
						token: storeToken,
						notification: {
							title: "Sparks",
							body: notificationMessage,
						},
						data: {
							id: userId,
							un: userName,
                            screen: "followed_user",
                            acct: "market",
							click_action: "FLUTTER_NOTIFICATION_CLICK",
						},
					};

					return admin
						.messaging()
						.send(message)
						.then((response) => {
							// Response is a message ID string.
							console.log("Successfully sent message:", response);
							return null;
						})
						.catch((error) => {
							console.log("Error sending message:", error);
							return null;
						});
				})
				.catch((error) => {
					console.log(error);
				});
		} else {
			return null;
		}
	});
