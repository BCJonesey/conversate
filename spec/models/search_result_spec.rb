require 'spec_helper'

describe SearchResult do
  it 'can initialize an action search result' do
    result = SearchResult.new('action',{
      'id' => 1234,
      'rank' => 0.095,
      'headline' => "but you're \u001Enever\u001E gonna find it free",
      'conversation_id' => 78,
      'title' => 'Might Find it Cheap',
      'participants' => "[\"Eric\", \"Erik\", \"Brian\", \"Michael\", \"Marty\"]",
      'folders' => "[12, 15]"
    })

    result.result_type.should eq 'action'
    result.result_id.should eq 1234
    result.rank.should eq 0.095
    result.headline.should eq ["but you're ", "never", " gonna find it free"]
    result.conversation_id.should eq 78
    result.conversation_title.should eq 'Might Find it Cheap'
    result.conversation_participants.should eq ['Eric', 'Erik', 'Brian', 'Michael', 'Marty']
    result.conversation_folders.should eq [12, 15]
  end
end
