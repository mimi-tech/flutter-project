'use-strict'

const functions = require('firebase-functions');
const admin     = require('firebase-admin');

exports.sendNotifyUserIMissedCallInviteAudio = functions.firestore
.document("calls/{friendId}/date/{dateId}/iMissedAudioCallInvite/{myId}")
.onWrite((change,context)=> {

  const friendId = context.params.friendId;
  const myId     = context.params.myId;
  const dateId   = context.params.dateId;
  const db       = admin.firestore();

  console.log(friendId + " missed an audio call invite from my user id: " + myId + ".");

  return db.collection("calls").doc(friendId)
  .collection("date").doc(dateId)
  .collection("iMissedAudioCallInvite").doc(myId)
  .get().then((queryResult)=>{

    const id   = queryResult.data().id;
    const nm   = queryResult.data().nm;
    const un   = queryResult.data().un;
    const em   = queryResult.data().em;
    const pimg = queryResult.data().pimg;
    //const tkn  = queryResult.data().tkn;
    const chn  = queryResult.data().chn;
    const ts   = queryResult.data().ts;
  
    //const f_data = db.collection("users").doc(myId).get();
    //const t_data = db.collection("users").doc(friendId).get();
    //return Promise.all([f_data, t_data]).then(result=>{
    //const inviter_un = result[0].data().un;
    //const my_un      = result[1].data().un;
    //const t_token    = result[1].data().tkn;
    
    const payload={
      notification:{
        title:"You missed",
        body:"an audio call."
      },
      data:{
        id:id,
        nm:nm,
        un:un,
        em:em,
        pimg:pimg,
        //tkn:tkn,
        chn:chn,
        ts:ts,
        ca:"TARGET_IMISSEDCALLINVITEAUDIO",
        click_action:"FLUTTER_NOTIFICATION_CLICK"
      }
    };
      
    //console.log(" | usernm: " + my_un + " missed an audio call invite from: " + inviter_un + ".");

    return admin.messaging().sendToTopic(friendId, payload);
  
  }).then((response) => {

    console.log("Successfully sent missed audio call invite notification to topic id: ", friendId, response);
    
    return null;
    
  }).catch((error)  => {

    console.error("Failure sending missed audio call invite notification to topic id: ", friendId, error);

  });

});