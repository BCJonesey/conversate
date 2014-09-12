require 'spec_helper'

describe Webhooks::V0::EmailController, focus: true do
  before(:all) do
    @sean = User.create(email: 'skermes@gmail.com',
                        full_name: 'Sean Kermes',
                        password: 'a')
    @support_folder = @sean.folders.create(name: 'Support',
                                           email: 'water-cooler-support')
  end

  describe 'POST #mandrill_inbound' do
    it 'ingests a message from GMail' do
      post :mandrill_inbound, mandrill_events: GMAIL_MESSAGE

      convo = @support_folder.conversations.order('created_at DESC').first
      convo.title.should eq 'Show up in the logs'

      message = convo.actions.where(type: 'email_message').first
      message.text.should eq 'This is the body of the email'
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
end
