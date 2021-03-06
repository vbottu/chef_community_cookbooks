# these tests only for redhat with iptables
require_relative 'spec_helper'

expected_rules = [
  # we included the .*-j so that we don't bother testing comments
  %r{-A INPUT -p tcp -m tcp -m state --state RELATED,ESTABLISHED .*-j ACCEPT},
  %r{-A INPUT -p tcp -m tcp -m multiport --dports 22 .*-j ACCEPT},
  %r{-A INPUT -p tcp -m tcp -m multiport --dports 2222,2200 .*-j ACCEPT},
  %r{-A INPUT -p tcp -m tcp -m multiport --dports 1234 .*-j DROP},
  %r{-A INPUT -p tcp -m tcp -m multiport --dports 1235 .*-j REJECT --reject-with icmp-port-unreachable},
  %r{-A INPUT -p tcp -m tcp -m multiport --dports 1236 .*-j DROP},
  %r{-A INPUT -s 192.168.99.99/32 -p tcp -m tcp .*-j REJECT --reject-with icmp-port-unreachable}
]

expected_ipv6_rules = [
  %r{-A INPUT -p tcp -m tcp -m state --state RELATED,ESTABLISHED .*-j ACCEPT},
  %r{-A INPUT -p tcp -m tcp -m multiport --dports 22 .*-j ACCEPT},
  %r{-A INPUT -p tcp -m tcp -m multiport --dports 2222,2200 .*-j ACCEPT},
  %r{-A INPUT -p tcp -m tcp -m multiport --dports 1234 .*-j DROP},
  %r{-A INPUT -p tcp -m tcp -m multiport --dports 1235 .*-j REJECT --reject-with icmp6-port-unreachable},
  %r{-A INPUT -p tcp -m tcp -m multiport --dports 1236 .*-j DROP},
  %r{-A INPUT -s 2001:db8::ff00:42:8329/128 -p tcp -m tcp -m multiport --dports 80 .*-j ACCEPT}
]

describe command('iptables-save'), :if => iptables? do
  its(:stdout) { should match(/COMMIT/) }

  expected_rules.each do |r|
    its(:stdout) { should match(r) }
  end

  # we try to get firewall to add this rule twice, but we expect to see it once!
  duplicate_rule1 = '-A INPUT -p tcp -m tcp -m multiport --dports 1111 -m comment --comment "same comment" -j ACCEPT'
  its(:stdout) { should count_occurences(duplicate_rule1, 1) }

  duplicate_rule2 = '-A INPUT -p tcp -m tcp -m multiport --dports 5432,5431 -m comment --comment "same comment" -j ACCEPT'
  its(:stdout) { should count_occurences(duplicate_rule2, 1) }
end

describe command('ip6tables-save'), :if => iptables? do
  its(:stdout) { should match(/COMMIT/) }

  expected_ipv6_rules.each do |r|
    its(:stdout) { should match(r) }
  end
end
