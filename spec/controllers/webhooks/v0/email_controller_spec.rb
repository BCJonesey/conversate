require 'spec_helper'

describe Webhooks::V0::EmailController, focus: true do
  before(:all) do
    @sean = User.create(email: 'skermes@gmail.com',
                        full_name: 'Sean Kermes',
                        password: 'a')
    @support_folder = @sean.folders.create(name: 'Support',
                                           email: 'water-cooler-support')

    @stuart = User.create(email: 'Stuart.Parker@kbcc.cuny.edu',
                          full_name: 'Stuart Parker',
                          password: 'a')
    @structural_folder = @stuart.folders.create(name: 'Structural',
                                                email: 'structural')
  end

  describe 'POST #mandrill_inbound' do
    it 'ingests a message from GMail' do
      post :mandrill_inbound, mandrill_events: GMAIL_MESSAGE

      convo = @support_folder.conversations.order('created_at DESC').first
      convo.title.should eq 'Show up in the logs'

      message = convo.actions.where(type: 'email_message').first
      message.text.should eq 'This is the body of the email'
    end

    it 'ingests a message from KBCC' do
      post :mandrill_inbound, mandrill_events: KBCC_MESSAGE

      convo = @structural_folder.conversations.order('created_at DESC').first
      convo.title.should eq 'Test'

      message = convo.actions.where(type: 'email_message').first
      message.text.should match /Here is a test message/
    end
  end

  GMAIL_MESSAGE = "[{\"event\":\"inbound\",
     \"ts\":1410469349,
     \"msg\":{
       \"raw_msg\": \"Received: from mail-la0-f53.google.com (unknown [209.85.215.53])\\n\\tby ip-10-196-133-123 (Postfix) with ESMTPS id 7139780899\\n\\tfor <water-cooler-support@watercooler.io>; Thu, 11 Sep 2014 21:02:28 +0000 (UTC)\\nReceived: by mail-la0-f53.google.com with SMTP id ge10so6482143lab.26\\n for <water-cooler-support@watercooler.io>; Thu, 11 Sep 2014 14:02:26 -0700 (PDT)\\nDKIM-Signature: v=1; a=rsa-sha256; c=relaxed\\/relaxed;\\n d=gmail.com; s=20120113;\\n h=mime-version:date:message-id:subject:from:to:content-type;\\n bh=qIcarlmMymqwmcM\\/eQvcAxl1NlcGOAmiBZBGhso1V3I=;\\n b=qE3K576KfoMadE2MMB8UJbRqdohBy93\\/j9V9YCkxq320U6vjwLr1slzT4GFvn8Ffc8\\n ijaWY+K\\/urKLN9tu7ZS8FxsWnG4HOT0etM2iFJOIkV+PCxKyTwsf7\\/ye24Ko2Wnry2JW\\n M3GFGref0Uhg+JjeRc4gMVdCBBmbZ8f245n\\/yPSwTMaJEr+OKjsX+M6QQTjhEgrJZvtH\\n HW7OTkkHSUQ04Lj\\/eit9sV5oqJCXjtL4Cl6EEWsyyDtY1v1P1vFctOLmon1w9yVSNWDs\\n Ilw35b68zEKFisz6BgZSLcqkRo6glqbGpQv+p+Ch8wVMTyadcgR8GfW0liuUm4g0eij4\\n icyw==\\nMIME-Version: 1.0\\nX-Received: by 10.152.7.38 with SMTP id g6mr4222591laa.26.1410469346066; Thu,\\n 11 Sep 2014 14:02:26 -0700 (PDT)\\nReceived: by 10.25.87.66 with HTTP; Thu, 11 Sep 2014 14:02:26 -0700 (PDT)\\nDate: Thu, 11 Sep 2014 17:02:26 -0400\\nMessage-ID: <CAGiR2V6qjrRv1SMu6giM4V0OQs5+FM-avzxX1G9tDVQQRLGXeA@mail.gmail.com>\\nSubject: Show up in the logs\\nFrom: Sean Kermes <skermes@gmail.com>\\nTo: water-cooler-support@watercooler.io\\nContent-Type: multipart\\/alternative; boundary=001a11c2906c56c5050502d07cd7\\n\\n--001a11c2906c56c5050502d07cd7\\nContent-Type: text\\/plain; charset=UTF-8\\n\\nThis is the body of the email\\n\\n--001a11c2906c56c5050502d07cd7\\nContent-Type: text\\/html; charset=UTF-8\\n\\n<div dir=\\\"ltr\\\">This is the body of the email<br><\\/div>\\n\\n--001a11c2906c56c5050502d07cd7--\",
       \"headers\":{
         \"Received\":[
           \"from mail-la0-f53.google.com (unknown [209.85.215.53]) by ip-10-196-133-123 (Postfix) with ESMTPS id 7139780899 for <water-cooler-support@watercooler.io>; Thu, 11 Sep 2014 21:02:28 +0000 (UTC)\",
           \"by mail-la0-f53.google.com with SMTP id ge10so6482143lab.26 for <water-cooler-support@watercooler.io>; Thu, 11 Sep 2014 14:02:26 -0700 (PDT)\",
           \"by 10.25.87.66 with HTTP; Thu, 11 Sep 2014 14:02:26 -0700 (PDT)\"
         ],
         \"Dkim-Signature\":\"v=1; a=rsa-sha256; c=relaxed\\/relaxed; d=gmail.com; s=20120113; h=mime-version:date:message-id:subject:from:to:content-type; bh=qIcarlmMymqwmcM\\/eQvcAxl1NlcGOAmiBZBGhso1V3I=; b=qE3K576KfoMadE2MMB8UJbRqdohBy93\\/j9V9YCkxq320U6vjwLr1slzT4GFvn8Ffc8 ijaWY+K\\/urKLN9tu7ZS8FxsWnG4HOT0etM2iFJOIkV+PCxKyTwsf7\\/ye24Ko2Wnry2JW M3GFGref0Uhg+JjeRc4gMVdCBBmbZ8f245n\\/yPSwTMaJEr+OKjsX+M6QQTjhEgrJZvtH HW7OTkkHSUQ04Lj\\/eit9sV5oqJCXjtL4Cl6EEWsyyDtY1v1P1vFctOLmon1w9yVSNWDs Ilw35b68zEKFisz6BgZSLcqkRo6glqbGpQv+p+Ch8wVMTyadcgR8GfW0liuUm4g0eij4 icyw==\",
         \"Mime-Version\":\"1.0\",
         \"X-Received\":\"by 10.152.7.38 with SMTP id g6mr4222591laa.26.1410469346066; Thu, 11 Sep 2014 14:02:26 -0700 (PDT)\",
         \"Date\":\"Thu, 11 Sep 2014 17:02:26 -0400\",
         \"Message-Id\":\"<CAGiR2V6qjrRv1SMu6giM4V0OQs5+FM-avzxX1G9tDVQQRLGXeA@mail.gmail.com>\",
         \"Subject\":\"Show up in the logs\",
         \"From\":\"Sean Kermes <skermes@gmail.com>\",
         \"To\":\"water-cooler-support@watercooler.io\",
         \"Content-Type\":\"multipart\\/alternative; boundary=001a11c2906c56c5050502d07cd7\"
       },
       \"text\":\"This is the body of the email\\n\\n\",
       \"text_flowed\":false,
       \"html\":\"<div dir=\\\"ltr\\\">This is the body of the email<br><\\/div>\\n\\n\",
       \"from_email\":\"skermes@gmail.com\",
       \"from_name\":\"Sean Kermes\",
       \"to\":[[\"water-cooler-support@watercooler.io\",null]],
       \"subject\":\"Show up in the logs\",
       \"spf\":{
         \"result\":\"pass\",
         \"detail\":\"sender SPF authorized\"
       },
       \"spam_report\":{
         \"score\":0.5,
         \"matched_rules\":[
           {\"name\":\"RCVD_IN_DNSWL_LOW\",
            \"score\":-0.7,
            \"description\":\"RBL: Sender listed at http:\\/\\/www.dnswl.org\\/, low\"
           },
           {\"name\":null,
            \"score\":0,
            \"description\":null
           },
           {\"name\":\"listed\",
            \"score\":0,
            \"description\":\"in list.dnswl.org]\"
           },
           {\"name\":\"FREEMAIL_FROM\",
            \"score\":0,
            \"description\":\"Sender email is commonly abused enduser mail provider\"
           },
           {\"name\":\"HTML_MESSAGE\",
            \"score\":0,
            \"description\":\"BODY: HTML included in message\"
           },
           {\"name\":\"DKIM_VALID_AU\",
            \"score\":-0.1,
            \"description\":\"Message has a valid DKIM or DK signature from author's\"
           },
           {\"name\":\"DKIM_SIGNED\",
            \"score\":0.1,
            \"description\":\"Message has a DKIM or DK signature, not necessarily valid\"
           },
           {\"name\":\"DKIM_VALID\",
            \"score\":-0.1,
            \"description\":\"Message has at least one valid DKIM or DK signature\"
           },
           {\"name\":\"RDNS_NONE\",
            \"score\":1.3,
            \"description\":\"Delivered to internal network by a host with no rDNS\"
           }
         ]
       },
       \"dkim\":{\"signed\":true,\"valid\":true},
       \"email\":\"water-cooler-support@watercooler.io\",
       \"tags\":[],
       \"sender\":null,
       \"template\":null
}}]"

  KBCC_MESSAGE = "[{\"event\":\"inbound\",
     \"ts\":1398087505,
     \"msg\":{\"raw_msg\":\"Received: from gateway.kingsborough.edu (unknown [198.83.119.108])\\n\\tby ip-10-220-3-120 (Postfix) with ESMTPS id A9A2F2012F\\n\\tfor <structural@watercooler.io>; Mon, 21 Apr 2014 13:38:24 +0000 (UTC)\\nReceived: from mail85b.kbcc.cuny.edu ([172.16.0.96])\\n\\tby gateway.kingsborough.edu (8.14.5\\/8.14.5) with ESMTP id s3LDcNHN000308\\n\\tfor <structural@watercooler.io>; Mon, 21 Apr 2014 09:38:23 -0400\\nX-Disclaimed: 1\\nMIME-Version: 1.0\\nSensitivity: \\nImportance: Normal\\nX-Priority: 3 (Normal)\\nIn-Reply-To: \\nReferences: \\nSubject: \\nFrom: Stuart.Parker@kbcc.cuny.edu\\nTo: structural@watercooler.io\\nMessage-ID: <OF5604CDE9.7A01CD88-ON85257CC1.004AEC47-85257CC1.004AEC4C@kbcc.cuny.edu>\\nDate: Mon, 21 Apr 2014 09:38:21 -0400\\nX-Mailer: Lotus Domino Web Server Release 9.0.1 HF193 January 23, 2014\\nX-MIMETrack: Serialize by HTTP Server on Mail85b\\/SVR\\/Kingsborough(Release 9.0.1 HF193|January\\n23, 2014) at 04\\/21\\/2014 09:38:21 AM,\\n\\tSerialize complete at 04\\/21\\/2014 09:38:21 AM,\\n\\tItemize by HTTP Server on Mail85b\\/SVR\\/Kingsborough(Release 9.0.1 HF193|January\\n 23, 2014) at 04\\/21\\/2014 09:38:21 AM,\\n\\tSerialize by Router on Mail85b\\/SVR\\/Kingsborough(Release 9.0.1 HF193|January\\n 23, 2014) at 04\\/21\\/2014 09:38:21 AM\\nX-KeepSent: 5604CDE9:7A01CD88-85257CC1:004AEC47;\\n type=4; name=$KeepSent\\nContent-Transfer-Encoding: quoted-printable\\nContent-Type: text\\/html;\\n\\tcharset=ISO-8859-1\\nX-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 phishscore=0\\n adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1\\n engine=7.0.1-1402240000 definitions=main-1404210223\\nX-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000\\n definitions=2014-04-21_01:2014-04-21,2014-04-20,1970-01-01 signatures=0\\n\\n<font face=3D\\\"Default Sans Serif,Verdana,Arial,Helvetica,sans-serif\\\" size=\\n=3D\\\"2\\\"><div>Here is a test message. &nbsp;I am just catching up on details =\\nafter working to finish two articles and get them out the door.<\\/div><div><=\\nbr><\\/div><div><br>Stuart Parker<br>Assistant Professor of Sociology<br>Depa=\\nrtment of Behavioral Sciences<br>Kingsborough Community College, The City U=\\nniversity of New York<\\/div><div><br><br><hr><br><font size=3D\\\"2\\\" font=3D\\\"\\\" =\\ncolor=3D\\\"DARK RED\\\"><br><p>-------------------------------------------------=\\n---------------------------------------------------------------<br>This ele=\\nctronic message transmission contains information that may be proprietary, =\\nconfidential and\\/or privileged. The information is intended only for the us=\\ne of the individual(s) or entity named above. If you are not the intended r=\\necipient, be aware that any disclosure, copying or distribution or use of t=\\nhe contents of this information is prohibited. If you have received this el=\\nectronic transmission in error, please delete it and any copies, and notify=\\n the sender immediately by replying to the address listed in the \\\"From:\\\" fi=\\neld. If you do not want to receive email from this source please contact po=\\nstmaster@kbcc.cuny.edu AND include the original message to be removed from.=\\n Thank you.<\\/p><br><font><br><br><\\/font><\\/font><\\/div><\\/font>\",
     \"headers\":{
       \"Received\":[
          \"from gateway.kingsborough.edu (unknown [198.83.119.108]) by ip-10-220-3-120 (Postfix) with ESMTPS id A9A2F2012F for <structural@watercooler.io>; Mon, 21 Apr 2014 13:38:24 +0000 (UTC)\",
          \"from mail85b.kbcc.cuny.edu ([172.16.0.96]) by gateway.kingsborough.edu (8.14.5\\/8.14.5) with ESMTP id s3LDcNHN000308 for <structural@watercooler.io>; Mon, 21 Apr 2014 09:38:23 -0400\"
       ],
       \"X-Disclaimed\":\"1\",
       \"Mime-Version\":\"1.0\",
       \"Sensitivity\":\"\",
       \"Importance\":\"Normal\",
       \"X-Priority\":\"3 (Normal)\",
       \"In-Reply-To\":\"\",
       \"References\":\"\",
       \"Subject\":\"\",
       \"From\":\"Stuart.Parker@kbcc.cuny.edu\",
       \"To\":\"structural@watercooler.io\",
       \"Message-Id\":\"<OF5604CDE9.7A01CD88-ON85257CC1.004AEC47-85257CC1.004AEC4C@kbcc.cuny.edu>\",
       \"Date\":\"Mon, 21 Apr 2014 09:38:21 -0400\",
       \"X-Mailer\":\"Lotus Domino Web Server Release 9.0.1 HF193 January 23, 2014\",
       \"X-Mimetrack\":\"Serialize by HTTP Server on Mail85b\\/SVR\\/Kingsborough(Release 9.0.1 HF193|January 23, 2014) at 04\\/21\\/2014 09:38:21 AM, Serialize complete at 04\\/21\\/2014 09:38:21 AM, Itemize by HTTP Server on Mail85b\\/SVR\\/Kingsborough(Release 9.0.1 HF193|January 23, 2014) at 04\\/21\\/2014 09:38:21 AM, Serialize by Router on Mail85b\\/SVR\\/Kingsborough(Release 9.0.1 HF193|January 23, 2014) at 04\\/21\\/2014 09:38:21 AM\",
       \"X-Keepsent\":\"5604CDE9:7A01CD88-85257CC1:004AEC47; type=4; name=$KeepSent\",
       \"Content-Transfer-Encoding\":\"quoted-printable\",
       \"Content-Type\":\"text\\/html; charset=ISO-8859-1\",
       \"X-Proofpoint-Spam-Details\":\"rule=notspam policy=default score=0 spamscore=0 suspectscore=2 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000 definitions=main-1404210223\",
       \"X-Proofpoint-Virus-Version\":\"vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000 definitions=2014-04-21_01:2014-04-21,2014-04-20,1970-01-01 signatures=0\"
      },
       \"html\":\"<font face=\\\"Default Sans Serif,Verdana,Arial,Helvetica,sans-serif\\\" size=\\\"2\\\"><div>Here is a test message. &nbsp;I am just catching up on details after working to finish two articles and get them out the door.<\\/div><div><br><\\/div><div><br>Stuart Parker<br>Assistant Professor of Sociology<br>Department of Behavioral Sciences<br>Kingsborough Community College, The City University of New York<\\/div><div><br><br><hr><br><font size=\\\"2\\\" font=\\\"\\\" color=\\\"DARK RED\\\"><br><p>----------------------------------------------------------------------------------------------------------------<br>This electronic message transmission contains information that may be proprietary, confidential and\\/or privileged. The information is intended only for the use of the individual(s) or entity named above. If you are not the intended recipient, be aware that any disclosure, copying or distribution or use of the contents of this information is prohibited. If you have received this electronic transmission in error, please delete it and any copies, and notify the sender immediately by replying to the address listed in the \\\"From:\\\" field. If you do not want to receive email from this source please contact postmaster@kbcc.cuny.edu AND include the original message to be removed from. Thank you.<\\/p><br><font><br><br><\\/font><\\/font><\\/div><\\/font>\",
       \"from_email\":\"Stuart.Parker@kbcc.cuny.edu\",
       \"to\":[[\"structural@watercooler.io\",null]],
       \"subject\":\"Test\",
       \"spf\":{
          \"result\":\"pass\",
          \"detail\":\"sender SPF authorized\"
       },
       \"spam_report\":{
          \"score\":3,
          \"matched_rules\":[
            {\"name\":\"URIBL_BLOCKED\",
             \"score\":0,
             \"description\":\"ADMINISTRATOR NOTICE: The query to URIBL was blocked.\"
            },
            {\"name\":null,
             \"score\":0,
             \"description\":null
            },
            {\"name\":\"more\",
             \"score\":0,
             \"description\":\"information.\"
            },
            {\"name\":\"cuny.edu]\",
             \"score\":0,
             \"description\":null
            },
            {\"name\":\"HTML_MESSAGE\",
             \"score\":0,\"description\":\"BODY: HTML included in message\"
            },
            {\"name\":\"MIME_HTML_ONLY\",
             \"score\":1.1,
             \"description\":\"BODY: Message only has text\\/html MIME parts\"
            },
            {\"name\":\"HTML_MIME_NO_HTML_TAG\",
             \"score\":0.6,
             \"description\":\"HTML-only message, but there is no HTML tag\"
            },
            {\"name\":\"RDNS_NONE\",
             \"score\":1.3,
             \"description\":\"Delivered to internal network by a host with no rDNS\"
            }
          ]
      },
      \"dkim\":{
        \"signed\":false,
        \"valid\":false
      },
      \"email\":\"structural@watercooler.io\",
      \"tags\":[],
      \"sender\":null,
      \"template\":null
}}]"
end
