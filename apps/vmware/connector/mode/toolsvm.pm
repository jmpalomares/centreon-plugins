#
# Copyright 2018 Centreon (http://www.centreon.com/)
#
# Centreon is a full-fledged industry-strength solution that meets
# the needs in IT infrastructure and application monitoring for
# service performance.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package apps::vmware::connector::mode::toolsvm;

use base qw(centreon::plugins::mode);

use strict;
use warnings;

sub new {
    my ($class, %options) = @_;
    my $self = $class->SUPER::new(package => __PACKAGE__, %options);
    bless $self, $class;
    
    $self->{version} = '1.0';
    $options{options}->add_options(arguments =>
                                {
                                  "vm-hostname:s"           => { name => 'vm_hostname' },
                                  "filter"                  => { name => 'filter' },
                                  "scope-datacenter:s"      => { name => 'scope_datacenter' },
                                  "scope-cluster:s"         => { name => 'scope_cluster' },
                                  "scope-host:s"            => { name => 'scope_host' },
                                  "filter-description:s"    => { name => 'filter_description' },
                                  "disconnect-status:s"     => { name => 'disconnect_status', default => 'unknown' },
                                  "display-description"     => { name => 'display_description' },
                                  "tools-notinstalled-status:s" => { name => 'tools_notinstalled_status', default => 'critical' },
                                  "tools-notrunning-status:s"   => { name => 'tools_notrunning_status', default => 'critical' },
                                  "tools-notup2date-status:s"   => { name => 'tools_notupd2date_status', default => 'warning' },
                                  "nopoweredon-skip"        => { name => 'nopoweredon_skip' },
                                });
    return $self;
}

sub check_options {
    my ($self, %options) = @_;
    $self->SUPER::init(%options);

    if ($self->{output}->is_litteral_status(status => $self->{option_results}->{disconnect_status}) == 0) {
        $self->{output}->add_option_msg(short_msg => "Wrong disconnect-status option '" . $self->{option_results}->{disconnect_status} . "'.");
        $self->{output}->option_exit();
    }
    if ($self->{output}->is_litteral_status(status => $self->{option_results}->{tools_notinstalled_status}) == 0) {
        $self->{output}->add_option_msg(short_msg => "Wrong tools-notinstalled-status option '" . $self->{option_results}->{tools_notinstalled_status} . "'.");
        $self->{output}->option_exit();
    }
    if ($self->{output}->is_litteral_status(status => $self->{option_results}->{tools_notrunning_status}) == 0) {
        $self->{output}->add_option_msg(short_msg => "Wrong tools-notrunning-status option '" . $self->{option_results}->{tools_notrunning_status} . "'.");
        $self->{output}->option_exit();
    }
    if ($self->{output}->is_litteral_status(status => $self->{option_results}->{tools_notupd2date_status}) == 0) {
        $self->{output}->add_option_msg(short_msg => "Wrong tools-notupd2date-status option '" . $self->{option_results}->{tools_notupd2date_status} . "'.");
        $self->{output}->option_exit();
    }
}

sub run {
    my ($self, %options) = @_;
    $self->{connector} = $options{custom};

    $self->{connector}->add_params(params => $self->{option_results},
                                   command => 'toolsvm');
    $self->{connector}->run();
}

1;

__END__

=head1 MODE

Check virtual machine tools.

=over 8

=item B<--vm-hostname>

VM hostname to check.
If not set, we check all VMs.

=item B<--filter>

VM hostname is a regexp.

=item B<--filter-description>

Filter also virtual machines description (can be a regexp).

=item B<--scope-datacenter>

Search in following datacenter(s) (can be a regexp).

=item B<--scope-cluster>

Search in following cluster(s) (can be a regexp).

=item B<--scope-host>

Search in following host(s) (can be a regexp).

=item B<--disconnect-status>

Status if VM disconnected (default: 'unknown').

=item B<--nopoweredon-skip>

Skip check if VM is not poweredOn.

=item B<--display-description>

Display virtual machine description.

=item B<--tools-notinstalled-status>

Status if vmtools is not installed (default: critical).

=item B<--tools-notrunning-status>

Status if vmtools is not running (default: critical).

=item B<--tools-notup2date-status>

Status if vmtools is not upd2date (default: warning).

=back

=cut
