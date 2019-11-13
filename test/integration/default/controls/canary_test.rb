describe host('10.128.0.11', port: 22, protocol: 'tcp') do
  it { should be_reachable }
  it { should be_resolvable }
end

describe http('https://hashicorp.com') do
  its('status') { should cmp 301 }
end