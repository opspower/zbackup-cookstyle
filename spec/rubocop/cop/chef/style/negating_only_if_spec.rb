#
# Copyright:: 2020, Chef Software, Inc.
# Author:: Tim Smith (<tsmith@chef.io>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe RuboCop::Cop::Chef::ChefStyle::NegatingOnlyIf do
  subject(:cop) { described_class.new }

  it 'registers an offense when a not_if negatives ruby' do
    expect_offense(<<~RUBY)
      package 'legacy-sysv-deps' do
        only_if { !foo }
        ^^^^^^^^^^^^^^^^ Use not_if instead of only_if that negates the Ruby statement with a !
      end
    RUBY

    expect_correction(<<~RUBY)
    package 'legacy-sysv-deps' do
      not_if { foo }
    end
    RUBY
  end

  it 'does not register an offense when an only_if double negates a variable' do
    expect_no_offenses(<<~RUBY)
      foo = true
      package 'legacy-sysv-deps' do
        only_if { !!foo }
      end
    RUBY
  end

  it 'does not register an offense when an only_if double negates' do
    expect_no_offenses(<<~RUBY)
      package 'legacy-sysv-deps' do
        only_if { !!foo }
      end
    RUBY
  end

  it 'does not register an offense when an only_if does not negate ruby' do
    expect_no_offenses(<<~RUBY)
        package 'legacy-sysv-deps' do
          only_if { foo }
        end
      RUBY
  end

  it 'does not register an offense when an only_if negates within the ruby' do
    expect_no_offenses(<<~RUBY)
        package 'legacy-sysv-deps' do
          only_if { foo && !bar }
        end
      RUBY
  end
end
