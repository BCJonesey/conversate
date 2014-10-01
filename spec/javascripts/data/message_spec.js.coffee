describe 'Data.Message', ->
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
