"use-strict";

const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.rateProfessionals = functions.firestore
	.document(
		"professionals/{profId}/professionalRatings/{userId}"
	)
	.onWrite(async (change, context) => {
		try {
			const db = admin.firestore();

			const userId = context.params.userId;
			const profId = context.params.profId;
			

			const dataBefore = change.before.data();
			const dataAfter = change.after.data();

			
			const profDoc = db.collection("professionals").doc(profId);

			/// Newly CREATED rating document
			if (dataBefore === undefined && dataAfter !== undefined) {
				console.log("CREATED running...");
				/// Variable holding the new rating value
				/// NOTE: This value is used in the [calculateNewRating] function
				const newRating = dataAfter.rt;

				/// Function take in the old rating, old rating count and new rating count together
				/// with the [newRating] to calculate the new rating average for the user
				/// and store based on the user's rating choice
				function calculateNewRating(oldRating, oldRateCount, newRateCount) {
					if (oldRateCount === 0) {
						let newCumRating = newRating / newRateCount;
						newCumRating = newCumRating.toFixed(2);
						newCumRating = Number(newCumRating);

						return newCumRating;
					} else {
						const oldCumulative = oldRating * oldRateCount;
						const newCumulative = oldCumulative + newRating;
						let newCumRating = newCumulative / newRateCount;
						newCumRating = newCumRating.toFixed(2);
						newCumRating = Number(newCumRating);

						return newCumRating;
					}
				}

				await db.runTransaction(async (transaction) => {
					const profData = await transaction.get(profDoc);

					
					/// Old "professional" rating data
					const oldProfRating = profData.data().avgRt;
					const oldProfRateCount = profData.data().rtc;


					/// New "professional" rating count
					const newProfRateCount = profData.data().rtc + 1;

					/// New professional average rating
					let avgProfRating = calculateNewRating(
						oldProfRating,
						oldProfRateCount,
						newProfRateCount
					);

					

				

					transaction.update(profDoc, {
						avgRt: avgProfRating,
						rtc: newProfRateCount,
					});

					
				});

				return db
					.collection("users")
					.doc(profId)
					.get()
					.then(async (query) => {
						const userToken = query.data().tkn;

						const userName = dataAfter.un;
						const userId = dataAfter.rId;

						const notificationMessage = ` Hello ${userName} gave you a reputation`;

						/// Message to be sent through FCM
						const message = {
							token: userToken,
							notification: {
								title: "Sparks",
								body: notificationMessage,
							},
							data: {
								id: profId,
								un: userName,
								screen: "reputation",
								acct: "jobs",
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
						return null;
					});
			}

			/// UPDATED rating document
			if (dataBefore !== undefined && dataAfter !== undefined) {
				console.log("UPDATED running...");
				/// Variable holding the rating value
				/// NOTE: These values are used in the [updateRating] function
				const prevRating = dataBefore.rt;
				const newRating = dataAfter.rt;

				if (prevRating !== newRating) {
					/// This function take in the old rating and old rating count together with
					/// the [prevRating] && [newRating] to calculate the new rating average for the
					/// product and store based on the updated user's rating choice
					function updateRating(oldRating, oldRateCount) {
						/// If the previous rating is less than the new rating, the value of the "prevRating"
						/// is subtracted from the "newRating" and the resulting value ADDED to the old
						/// cumulative value and the average rating re-calculated
						if (prevRating < newRating) {
							const rateDiff = newRating - prevRating;

							const oldCumulative = oldRating * oldRateCount;
							const newCumulative = oldCumulative + rateDiff;
							let newCumRating = newCumulative / oldRateCount;
							newCumRating = newCumRating.toFixed(2);
							newCumRating = Number(newCumRating);

							return newCumRating;
						}

						/// If the previous rating is less than new rating, the value of the "newRating"
						/// is subtracted from the "prevRating" and the resulting value SUBTRACTED from the old
						/// cumulative value and the average rating re-calculated
						if (prevRating > newRating) {
							const rateDiff = prevRating - newRating;

							const oldCumulative = oldRating * oldRateCount;
							const newCumulative = oldCumulative - rateDiff;
							let newCumRating = newCumulative / oldRateCount;
							newCumRating = newCumRating.toFixed(2);
							newCumRating = Number(newCumRating);

							return newCumRating;
						}
					}

					await db
						.runTransaction(async (transaction) => {
							const profData = await transaction.get(profDoc);

					
							/// Old "professional" rating data
							const oldProfRating = profData.data().avgRt;
							const oldProfRateCount = profData.data().rtc;



							/// New store average rating
							let avgProfRating = updateRating(
								oldProfRating,
								oldProfRateCount
							);
							
							
							transaction.update(profDoc, {
								avgRt: avgProfRating,
							});

							
						})
						.then(() => {
							return null;
						})
						.catch((error) => {
							console.log("Error with transaction", error);
							return null;
						});
				} else {
					return null;
				}
			}

		} catch (error) {
			console.log("Try catch error", error);
		}
	});
