// To be run in xpcshell
// https://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central/firefox-*.en-US.win64.common.tests.zip - bin\xpcshell.exe
// Source: https://github.com/eqsoft/seb2/blob/15b9bf9282c1fe9b05e01434c3bdcaea64503714/certdb/app/modules/certdb.jsm#L354-L369

let certdb = Cc["@mozilla.org/security/x509certdb;1"].getService(Ci.nsIX509CertDB);
let certlist = certdb.getCerts();
let enumerator = certlist.getEnumerator();

// Display CA names
//while (enumerator.hasMoreElements()) { let cert = enumerator.getNext().QueryInterface(Ci.nsIX509Cert); console.log("issuer: " + cert.issuerName); }

// Distrust all
while (enumerator.hasMoreElements()) { let cert = enumerator.getNext().QueryInterface(Ci.nsIX509Cert); certdb.setCertTrust(cert, Ci.nsIX509Cert.ANY_CERT, Ci.nsIX509CertDB.UNTRUSTED); }

// Delete all ???
//while (enumerator.hasMoreElements()) { let cert = enumerator.getNext().QueryInterface(Ci.nsIX509Cert); certdb.deleteCertificate(cert); }
