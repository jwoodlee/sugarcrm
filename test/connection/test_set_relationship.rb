require 'helper'

class TestSetRelationship < Test::Unit::TestCase    
  context "A SugarCRM.connection" do
    should "add and remove a relationship when #set_relationship" do
      SugarCRM.connect(URL, USER, PASS, {:debug => false})    
      meeting  = SugarCRM::Meeting.new
      SugarCRM.connection.debug = true
      meeting.date_start = DateTime.now
      meeting.duration_hours = 0.5
      meeting.name = "Stupid Meeting"
      meeting.valid?
      pp meeting.errors
      puts "saving"
      assert meeting.save!
      assert !meeting._id.nil?
      response = SugarCRM.connection.set_relationship("Users","1","Meetings", [meeting._id])
      puts "relating: User seed_will_id -> Meetings #{meeting._id}"
      pp response
      assert response["created"] == 1
      response = SugarCRM.connection.set_relationship("Users","1","Meetings", [meeting._id], {:delete => 1})
      puts "unrelating"
      assert response["deleted"] == 1
      puts "deleting"
      assert meeting.delete
      SugarCRM.connection.debug = false
    end
  end
end