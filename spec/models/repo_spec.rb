require "rails_helper"

describe Repo do
  include GithubApiHelpers

  describe "#contributors" do
    it "returns a list of contributors to the repo" do
      stub_github_data(pulls: [stub_contribution(handle: "foobar")])
      repo = Repo.new("graysonwright/osbot")

      contributors = repo.contributors

      expect(contributors.first.handle).to eq("foobar")
    end

    it "assigns the permissions from the repository to the contributors" do
      handle = "foobar"
      collaborator_info = stub_collaborator(
        handle: handle,
        admin: true,
        push: true,
        pull: true
      )
      stub_github_data(
        collabs: [collaborator_info],
        pulls: [stub_contribution(handle: handle)],
      )
      repo = Repo.new("graysonwright/osbot")

      contributor = repo.contributors.first

      expect(contributor.admin_permissions?).to be_truthy
      expect(contributor.push_permissions?).to be_truthy
      expect(contributor.pull_permissions?).to be_truthy
    end

    it "assigns pull requests from the repository to their author" do
      handle = "foobar"
      stub_github_data(pulls: [stub_contribution(handle: handle)])
      repo = Repo.new("graysonwright/osbot")

      contributor = repo.contributors.first

      expect(contributor.handle).to eq(handle)
      expect(contributor.score).to be > 0
    end

    it "assigns issues from the repository to their author" do
      handle = "foobar"
      stub_github_data(issues: [stub_contribution(handle: handle)])
      repo = Repo.new("graysonwright/osbot")

      contributor = repo.contributors.first

      expect(contributor.handle).to eq(handle)
      expect(contributor.score).to be > 0
    end

    it "assigns issue comments from the repository to their author" do
      handle = "foobar"
      stub_github_data(issues_comments: [stub_contribution(handle: handle)])
      repo = Repo.new("graysonwright/osbot")

      contributor = repo.contributors.first

      expect(contributor.handle).to eq(handle)
      expect(contributor.score).to be > 0
    end

    it "assigns pull request comments from the repository to their author" do
      handle = "foobar"
      stub_github_data(pulls_comments: [stub_contribution(handle: handle)])
      repo = Repo.new("graysonwright/osbot")

      contributor = repo.contributors.first

      expect(contributor.handle).to eq(handle)
      expect(contributor.score).to be > 0
    end

    it "excludes people who have access to the repo but haven't contributed"
  end
end
