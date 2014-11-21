describe 'Data.Message', ->
  describe 'isUnread', ->
    {isUnread} = Structural.Data.Message

    it 'is unread when it\'s later', ->
      msg =
        text: 'Heyo'
        timestamp: 12345

      convo =
        title: 'My Convo'
        most_recent_viewed: 12333

      expect(isUnread(msg, convo)).toBe(true)

    it 'is not unread when it\'s earlier', ->
      msg =
        text: 'Heyo'
        timestamp: 12333

      convo =
        title: 'My Convo'
        most_recent_viewed: 12345

      expect(isUnread(msg, convo)).toBe(false)

  describe 'buildMessage', ->
    {buildMessage} = Structural.Data.Message

    beforeEach ->
      rightNow = new Date(2014, 10, 7, 14, 15)
      spyOn(window, 'Date').and.returnValue(rightNow)
      @rightNowTimestamp = rightNow.valueOf()

    it 'builds a message with default type', ->
      expected =
        type: 'message'
        user:
          id: 10
          email: 'alice@example.com'
        text: 'Testing testing'
        timestamp: @rightNowTimestamp

      user =
        id: 10
        email: 'alice@example.com'

      expect(buildMessage(user, 'Testing testing')).toEqual(expected)

    it 'builds a message with the supplied type', ->
      expected =
        type: 'email_message'
        user:
          id: 20
          email: 'bob@example.com'
        text: 'Hey everyone'
        timestamp: @rightNowTimestamp

      user =
        id: 20
        email: 'bob@example.com'

      expect(buildMessage(user, 'Hey everyone', 'email_message')).toEqual(expected)

  describe 'isUsersMessage', ->
    {isUsersMessage} = Structural.Data.Message

    it 'returns false when the user doesn\'t exist', ->
      expect(isUsersMessage({user: {id: 1}}, undefined)).toBe(false)

    it 'returns true when the message\'s user id matches the user\'s', ->
      expect(isUsersMessage({user: {id: 1}}, {id: 1})).toBe(true)

    it 'returns false when the ids don\'t match', ->
      expect(isUsersMessage({user: {id: 1}}, {id: 2})).toBe(false)

  describe 'latestTimestamp', ->
    {latestTimestamp} = Structural.Data.Message

    it 'gets the timestamp for a message with no follow ons', ->
      noFollowOn =
        type: 'message'
        timestamp: 123456
        id: 34

      expect(latestTimestamp(noFollowOn)).toBe(123456)

    it 'gets the timestamp for a message with empty follow ons', ->
      emptyFollowOns =
        type: 'message'
        timestamp: 123456
        id: 29
        followOns: []

      expect(latestTimestamp(emptyFollowOns)).toBe(123456)

    it 'gets the timestamp for a message with some follow ons', ->
      followOns =
        type: 'message'
        timestamp: 123456
        id: 89
        followOns: [
          {
            type: 'message'
            timestamp: 123789
            id: 90
          }
          {
            type: 'message'
            timestamp: 125678
            id: 91
          }
        ]

      expect(latestTimestamp(followOns)).toBe(125678)

  describe 'distillRawMessages', ->
    {distillRawMessages} = Structural.Data.Message

    it 'distills an empty array into an empty array', ->
      expect(distillRawMessages([])).toEqual([])

    it 'distills an array with no follow ons into the same array', ->
      noFollowOns = [
        {
          type: 'message'
          id: 10
          timestamp: 123456
          user:
            id: 1
        }
        {
          type: 'message'
          id: 11
          timestamp: 123457
          user:
            id: 2
        }
        {
          type: 'message'
          id: 12
          timestamp: 523457
          user:
            id: 2
        }
        {
          type: 'retitle'
          id: 13
          timestamp: 523458
          user:
            id: 2
        }
      ]

      expect(distillRawMessages(noFollowOns)).toEqual(noFollowOns)

    it 'distills an array with follow ons', ->
      followOns = [
        {
          type: 'message'
          id: 10
          timestamp: 123456
          user:
            id: 1
        }
        {
          type: 'message'
          id: 11
          timestamp: 133456
          user:
            id: 1
        }
        {
          type: 'retitle'
          id: 12
          timestamp: 133556
          user:
            id: 1
        }
        {
          type: 'message'
          id: 13
          timestamp: 143556
          user:
            id: 2
        }
        {
          type: 'email_message'
          id: 14
          timestamp: 153556
          user:
            id: 2
        }
      ]

      distilled = [
        {
          type: 'message'
          id: 10
          timestamp: 123456
          user:
            id: 1
          followOns: [
            {
              type: 'message'
              id: 11
              timestamp: 133456
              user:
                id: 1
            }
          ]
        }
        {
          type: 'retitle'
          id: 12
          timestamp: 133556
          user:
            id: 1
        }
        {
          type: 'message'
          id: 13
          timestamp: 143556
          user:
            id: 2
          followOns: [
            {
              type: 'email_message'
              id: 14
              timestamp: 153556
              user:
                id: 2
            }
          ]
        }
      ]

      expect(distillRawMessages(followOns)).toEqual(distilled)
