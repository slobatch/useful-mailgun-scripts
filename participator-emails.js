// Replace the elements of this array with strings that correspond exactly
// with the titles of the pads you would like to get the participators from.
var pads = ["Knotel teaching.","Knotel Dinner, Monday, April 28 - DLD Week Edition","Knotel dinner / Sep 30th / Thanks from Edward and Amol","Startup Boost / Knotel courses / Oct","SXSW Future of Work, Work ADD, Getting Things Done, Nirvana. / #ship","10x Product with Code As Cards.","Code As Cards. The System.","Startup Club for Founders Who Know Amol"];
var accountIds = [];
var userIds = [];
var emails = [];
var emailString = "";

//Get All User Account Ids for each pad

for (var i = 0; i < pads.length; i++) {
  db.topics.find({changed_subject:pads[i]}, {participator_account_ids: 1}).forEach(function(doc) {
    for (var i = 0; i < doc.participator_account_ids.length; i++) {
        accountIds.push(doc.participator_account_ids[i]);
    }
  });
}

//print("accountIds.length:" + accountIds.length);
//print(accountIds);

// Get User Ids associated with each User Account Ids

for (var i = 0; i < accountIds.length; i++) {
    db.user_accounts.find({_id:accountIds[i]}).forEach(function(doc){
          userIds.push(doc.user_ids[0]);
    })
}

//print("userIds.length:" + userIds.length);
//print(userIds);

// Get Emails associated with each User Id

for (var i = 0; i < userIds.length; i++) {
    db.users.find({_id:userIds[i]}).forEach(function(doc){
          emails.push(doc.emails[0].address);
    })
}

// Remove duplicates

function uniq_fast(a) {
    var seen = {};
    var out = [];
    var len = a.length;
    var j = 0;
    for(var i = 0; i < len; i++) {
         var item = a[i];
         if(seen[item] !== 1) {
               seen[item] = 1;
               out[j++] = item;
         }
    }
    return out;
}

emails = uniq_fast(emails);

//print("emails.length:" + emails.length);
//print(emails);

// Create and print string.

for (var i = 0; i < emails.length; i++) {
    emailString+=emails[i]+",\n";
}

print(emailString);
