require 'spec_helper'

describe Gitlab::GoogleCodeImport::ProjectCreator do
  let(:user) { create(:user) }
  let(:repo) { 
    Gitlab::GoogleCodeImport::Repository.new(
      "name"            => 'vim',
      "summary"         => 'VI Improved',
      "repositoryUrls"  => [ "https://vim.googlecode.com/git/" ]
    )
  }
  let(:namespace) { create(:namespace) }

  it 'creates project' do
    allow_any_instance_of(Project).to receive(:add_import_job)

    project_creator = Gitlab::GoogleCodeImport::ProjectCreator.new(repo, namespace, user)
    project_creator.execute
    project = Project.last
    
    expect(project.import_url).to eq("https://vim.googlecode.com/git/")
    expect(project.visibility_level).to eq(Gitlab::VisibilityLevel::PUBLIC)
  end
end
