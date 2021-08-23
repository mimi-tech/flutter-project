const functions = require('firebase-functions');
const admin     = require("firebase-admin");
admin.initializeApp();

// com
const sendOnlinePresence  = require('./lib/com/sendOnlinePresence');
const sendUploadContacts  = require('./lib/com/sendUploadContacts');
const sendCallInviteAudio = require('./lib/com/sendCallInviteAudio');
const sendCallInviteVideo = require('./lib/com/sendCallInviteVideo');
const sendNotifyUserIMissedCallInviteAudio = require('./lib/com/sendNotifyUserIMissedCallInviteAudio');
const sendNotifyUserIMissedCallInviteVideo = require('./lib/com/sendNotifyUserIMissedCallInviteVideo');

exports.sendOnlinePresence  = sendOnlinePresence.sendOnlinePresence;
exports.sendUploadContacts  = sendUploadContacts.sendUploadContacts;
exports.sendCallInviteAudio = sendCallInviteAudio.sendCallInviteAudio;
exports.sendCallInviteVideo = sendCallInviteVideo.sendCallInviteVideo;
exports.sendNotifyUserIMissedCallInviteAudio = sendNotifyUserIMissedCallInviteAudio.sendNotifyUserIMissedCallInviteAudio;
exports.sendNotifyUserIMissedCallInviteVideo = sendNotifyUserIMissedCallInviteVideo.sendNotifyUserIMissedCallInviteVideo;

// home
const likePostFromHomeScreen = require('./lib/home/likePostFromHomeScreen');
const commentOnHomePost      = require('./lib/home/commentOnHomePost');
const likeCommentFromHome = require('./lib/home/likeCommentFromHome');
const repliesOnHomeComment = require('./lib/home/repliesOnHomeComment');

exports.likePostFromHomeScreen = likePostFromHomeScreen.likePostFromHomeScreen;
exports.commentOnHomePost      = commentOnHomePost.commentOnHomePost;
exports.likeCommentFromHome = likeCommentFromHome.likeCommentFromHome;
exports.repliesOnHomeComment = repliesOnHomeComment.repliesOnHomeComment;

// market
const deleteRecentlyViewed              = require('./lib/market/deleteRecentlyViewed');
const storeNewFolNotification           = require('./lib/market/storeNewFolNotification');
const sendProductListingNotification    = require('./lib/market/sendProductListingNotification');

exports.deleteRecentlyViewed            = deleteRecentlyViewed.deleteRecentlyViewed;
exports.storeNewFolNotification         = storeNewFolNotification.storeNewFolNotification;
exports.sendProductListingNotification  = sendProductListingNotification.sendProductListingNotification;

<<<<<<< HEAD


//classroom
const userVerifiedCourses                 = require('./lib/classroom/userVerifiedCourses');
const companyVerifiedCourses              = require('./lib/classroom/companyVerifiedCourses');
const sparksCourseHandler                 = require('./lib/classroom/sparksCourseHandler');
const expertClassCompanies                 = require('./lib/classroom/expertClassCompanies');
const classOwner                           = require('./lib/classroom/classOwner');
const sparksExpertClassHandler             = require('./lib/classroom/sparksExpertClassHandler');
const expertClassAdmin                     = require('./lib/classroom/expertClassAdmin');
const allFriendsClass                     = require('./lib/classroom/allFriendsClass');
const allFriendsCourses                     = require('./lib/classroom/allFriendsCourses');
const allFriendsLive                     = require('./lib/classroom/allFriendsLive');
const allFriendsUpload                     = require('./lib/classroom/allFriendsUpload');


exports.userVerifiedCourses                = userVerifiedCourses.userVerifiedCourses;
exports.companyVerifiedCourses             = companyVerifiedCourses.companyVerifiedCourses;
exports.sparksCourseHandler                = sparksCourseHandler.sparksCourseHandler;
exports.expertClassCompanies                = expertClassCompanies.expertClassCompanies;
exports.classOwner                          = classOwner.classOwner;
exports.sparksExpertClassHandler            = sparksExpertClassHandler.sparksExpertClassHandler;
exports.expertClassAdmin                      = expertClassAdmin.expertClassAdmin;
exports.allFriendsClass                      = allFriendsClass.allFriendsClass;
exports.allFriendsCourses                      = allFriendsCourses.allFriendsCourses;
exports.allFriendsLive                      = allFriendsLive.allFriendsLive;
exports.allFriendsUpload                      = allFriendsUpload.allFriendsUpload;


=======
// jobs
const rateProfessionals                 = require('./lib/jobs/rateProfessionals');

exports.rateProfessionals               = rateProfessionals.rateProfessionals;
>>>>>>> dd1747434f2bd284ff34d208ffebfe5728e111a0
