"use-strict";

const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.sendProductListingNotification = functions.firestore
	.document("stores/{storeId}/userStore/{category}/{condition}/{documentId}")
	.onCreate(async (snap, context) => {
		const productData = snap.data();

		if (productData) {

            const db = admin.firestore();

            const storeId = context.params.storeId;

            const storeNameQuery    = await db.collection("stores").doc(storeId).get();

            if(storeNameQuery.exists) {
                const storeName     = storeNameQuery.data().stNm;

                console.log(storeName);

                const commonId  = productData.cmId;
                const rate      = productData.rate.toString();
                const category  = productData.prC;
                const imageUrl  = productData.prImg[0];
                const pName     = productData.prN;
                const price     = productData.price.toString();
                const condition = context.params.condition;

                /// Function that take the plural word (category) and converts it into a singular word
                function singularCategory(cate) {
                    let result = "";

                    cate = cate.toLowerCase();

                    const lastIndex = cate.length - 1;
                
                    if(cate[lastIndex] === "s") {
                        result = cate.substring(0, lastIndex);
                    } else {
                        result = cate;
                    }
                    return result;
                }

                const notificationCategory  = singularCategory(category);

                /// Notification body text
                const content   = `${storeName} has a new ${notificationCategory} in their store`;

                const topic     = "store" + storeId;

                const payload   = {
                    notification: {
                        title: "Sparks",
                        body: content,
                    },
                    data: {
                        cmId: commonId,
                        rate: rate,
                        id: storeId,
                        stNm: storeName,
                        prC: category,
                        prImg: imageUrl,
                        prN: pName,
                        price: price,
                        cond: condition,
                        screen: "product_detail",
                        acct: "market",
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                    },
                };

                const option    = {
                    time_to_live: 5400,
                }

                return admin
                    .messaging()
                    .sendToTopic(topic, payload, option)
                    .then((response) => {
                        console.log("Successfully sent topic message:", response);
                        return null;
                    })
                    .catch((error) => {
                        console.log("An error occurred:", error);
                        return null;
                    });
            }
		}
	});
