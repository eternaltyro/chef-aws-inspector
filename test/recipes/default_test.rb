# # encoding: utf-8

# Inspec test for recipe aws-inspector::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

if os.family == 'windows'
  describe service('AWSAgent') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
  describe service('AWSAgentUpdater') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
else
  describe service('awsagent') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
