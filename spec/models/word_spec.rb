### BEGIN LICENSE
# Copyright (C) 2012 Benoît Legat benoit.legat@gmail.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
### END LICENSE

require 'spec_helper'

describe Word do

  let (:language) { FactoryGirl.create(:language) }
  before do
    @word = FactoryGirl.build(:word, language: language)
  end

  subject { @word }

  it { should be_valid }
  it { should respond_to(:content) }
  it { should respond_to(:language) }
  its(:language) { should == language }
  describe "accessible attributes" do
    it "should not allow access to language_id" do
      expect do
        Word.new(content:"test",language_id: language.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when content is not present" do
    before { @word.content = nil }
    it { should_not be_valid }
  end
  describe "when content is blank" do
    before { @word.content = " " }
    it { should_not be_valid }
  end
  describe "when content is too long" do
    before { @word.content = "A" + "a" * 64 }
    it { should_not be_valid }
  end

  describe "when content has non-alnum characters" do
    before { @word.content = "a|b" }
    it { should_not be_valid }
  end
  describe "when content has digits" do
    before { @word.content = "a0b" }
    it { should be_valid }
  end
  #describe "when content has accents characters" do
  #  before { @word.content = "åbæéà" }
  #  it { should be_valid }
  #end # FIXME
  describe "when it belongs to no language" do
    before do
      @word_without_language = Word.new(content:"house")
    end
    subject { @word_without_language }
    it { should_not be_valid }
  end

end
