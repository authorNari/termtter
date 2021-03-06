#-*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__)) + '/../spec_helper.rb'

describe Termtter::Client, 'when the plugin footer is loaded' do
  @r = nil
  before(:all) do
    @r = nil
    Termtter::Client.clear_hooks
    Termtter::Client.setup_task_manager

    config.footer = "[termtter]"

  end

  before do
    @r = nil
    Termtter::Client.register_command(:name => :update, :aliases => [:u], :exec => lambda{|arg| @r = arg })
    Termtter::Client.plug 'footer'
  end

  it 'should add hook add_footer and command footer' do
    Termtter::Client.should_receive(:register_hook).once
    Termtter::Client.should_receive(:register_command).once
    Termtter::Client.plug 'footer'
  end

  it 'should add footer at update' do
    @r.should be_nil
    Termtter::Client.execute('update foo')
    config.footer.should == '[termtter]'
    @r.should == 'foo [termtter]'
  end

  it 'should call footer command to change config.footer' do
    Termtter::Client.execute('footer #termtter')
    config.footer.should == '#termtter'
    @r.should be_nil
    Termtter::Client.execute('update bar')
    @r.should == 'bar #termtter'
  end

  it 'should call footer no argument to set config.footer to nil' do
    Termtter::Client.execute('footer')
    config.footer.should == nil
    @r.should be_nil
    Termtter::Client.execute('update hoge')
    @r.should == 'hoge'
  end
end

