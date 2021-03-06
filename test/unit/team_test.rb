require File.dirname(__FILE__) + '/../test_helper'

class TeamTest < ActiveSupport::TestCase
  context "Team" do
    setup do
      Factory(:team)
    end
    ################################################################################################################
    #
    # Associations
    #
    ################################################################################################################
    should_have_and_belong_to_many :users
    should_have_and_belong_to_many :projects
    should_belong_to :organization

    ################################################################################################################
    #
    # Validations
    #
    ################################################################################################################
    should_validate_uniqueness_of :name
    should_validate_presence_of :name, :organization
  end
  
  ################################################################################################################
  #
  # Instance methods
  #
  ################################################################################################################
  context "#stories" do
    setup do
      @project1 = Factory(:project)
      @project2 = Factory(:project)
      @team = Factory(:team)
      @project1.teams << @team
      @project2.teams << @team
    end

    should "return all the stories for the team (including all its projects)" do
      assert_equal @project1.stories + @project2.stories, @team.stories
    end
  end
  
end
