# -*- coding: utf-8 -*-
require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'spec_helper')

# Twitterとのやり取り部分はMockにする
module SuddenKiller
  class TwitterInterface
    attr_reader :posted_text, :followed_user_id

    def post(text)
      @posted_text = text
    end

    def follow(user_id)
      @followed_user_id = user_id
    end
  end
end

describe SK::TwitterInterface do
  before do
    @killer = SK::Killer.new(File.join(SK.root, 'okura-dic'))
    @interval = 10
  end

  context "followされたとき" do
    before do
      @twitter_interface = SK::TwitterInterface.new(@killer, @interval)
      @user_id = 2
      status = {:event => 'follow', :source => {:id => @user_id}}
      @twitter_interface.send(:recieve_status, status)
    end

    it "refollowする" do
      @twitter_interface.followed_user_id.should == @user_id
    end
  end

  context "tweetを受け取ったとき" do
    before do
      @twitter_interface = SK::TwitterInterface.new(@killer, @interval)
    end

    it "ひっかからない文字列なら何もしない" do
      status = {:text => 'ニャーン！',:user => {:protected => false}}
      @twitter_interface.send(:recieve_status, status)
      @twitter_interface.posted_text.should == nil
    end

    it "スクリーンネームが含まれるtweetは無視する" do
      status = {:text => 'RT:@nya--n 私黒髪で病弱でワンピースの似合う妹系の美少女だけど、sudden killerさんかっこいいと思う',:user => {:protected => false}}
      @twitter_interface.send(:recieve_status, status)
      @twitter_interface.posted_text.should == nil
    end

    it "140字超える場合は無視する" do
      status = {:text => 'x' * 140 + '私黒髪で病弱でワンピースの似合う妹系の美少女だけど、sudden killerさんかっこいいと思う',:user => {:protected => false}}
      @twitter_interface.send(:recieve_status, status)
      @twitter_interface.posted_text.should == nil
    end

    it "短かすぎる場合無視する" do
      status = {:text => '私美少女だけど、sudden killerさんかっこいいと思う',:user => {:protected => false}}
      @twitter_interface.send(:recieve_status, status)
      @twitter_interface.posted_text.should == nil
    end

    it "protectedなユーザのtweetは無視する" do
      status = {:text => '私黒髪で病弱でワンピースの似合う妹系の美少女だけど、sudden killerさんかっこいいと思う',:user => {:protected => true}}
      @twitter_interface.send(:recieve_status, status)
      @twitter_interface.posted_text.should be_nil
    end

    it "ひっかかる文字列なら突然死する" do
      status = {:text => '私黒髪で病弱でワンピースの似合う妹系の美少女だけど、sudden killerさんかっこいいと思う',:user => {:protected => false}}
      @twitter_interface.send(:recieve_status, status)
      @twitter_interface.posted_text.should ==
        '私黒髪で病弱でワンピースの似合う妹系の美少女だけど' + SK::TOTSUZENSHI_AA
    end
  end

  context "以前にtweetしているとき" do
    before do
      @base_time = Time.now
      Timecop.freeze(@base_time)

      @twitter_interface = SK::TwitterInterface.new(@killer, @interval)
      status = {:text => '私黒髪で病弱でワンピースの似合う妹系の美少女だけど、sudden killerさんかっこいいと思う',:user => {:protected => false}}
      @twitter_interface.send(:recieve_status, status)
    end

    it "#{@interval}分間はひっかかる文字列があってもtweetしない" do
      Timecop.freeze(@base_time + (@interval * 60) - 1)
      status = {
        :text => '新しいtweetがあっても、なにもしない。私黒髪で病弱でワンピースの似合う妹系の美少女だけど、sudden killerさんかっこいいと思う',
        :user => {:protected => false}
      }
      @twitter_interface.send(:recieve_status, status)
      @twitter_interface.posted_text.should ==
        "私黒髪で病弱でワンピースの似合う妹系の美少女だけど" + SK::TOTSUZENSHI_AA #以前のまま
    end

    it "#{@interval}分後はひっかかる文字列があったらtweetする" do
      Timecop.freeze(@base_time + (@interval * 60) + 1)
      status = {
        :text => '新しいtweetがあったら、tweetする。私黒髪で病弱でワンピースの似合う妹系の美少女だけど、sudden killerさんかっこいいと思う',
        :user => {:protected => false}
      }
      @twitter_interface.send(:recieve_status, status)
      @twitter_interface.posted_text.should ==
        "新しいtweetがあったら、tweetする。私黒髪で病弱でワンピースの似合う妹系の美少女だけど" + SK::TOTSUZENSHI_AA #postした
    end
  end
end
