# -*- coding: utf-8 -*-
require 'okura/serializer'
module SuddenKiller
  class Killer

    PATTERNS = [
      [{:word_class => "動詞"}, {:word_class => "助詞", :surface => "て"}].freeze,
      [{:word_class => "名詞"}, {:word_class => "助動詞", :surface => "だ"}, {:word_class => "助詞", :surface => "と"}].freeze,
    ].freeze

    def initialize(dict_dir)
      @dict_dir = dict_dir
    end

    def kill(text)
      words = parse(text)
      words = words.select { |e| e.surface != "BOS/EOS"}
      words = words.map{|w|
        {
          :surface    => w.surface,
          :word_class => w.left.text.split(",")[0]
        }
      }

      index = 0
      while ! words.empty?
        if match?(words)
          ret =  words.map{|w|w[:surface]}.join + SK::TOTSUZENSHI_AA
          return ret
        end
        words.pop
      end

      return
    end

    private

    #wordsの末尾がマッチするかチェック
    def match?(words)
      PATTERNS.each do |pattern|
        next if pattern.size > words.size

        matched = true
        last_words = words.last(pattern.size)

        0.upto(pattern.size-1) { |index|
          #patternとwords両方に存在するキーについて同値チェック
          keys_to_check = last_words[index].keys & pattern[index].keys
          unless ( keys_to_check.all?{ |key| last_words[index][key] == pattern[index][key]} )
            matched = false
          end
        }

        return true if matched
      end

      return false
    end

    def tagger
      @tagger=Okura::Serializer::FormatInfo.create_tagger @dict_dir
      @tagger
    end

    def parse(text)
      nodes = tagger.parse(text)
      words = [];
      nodes.mincost_path.each{|node|
        words.push node.word
      }
      words
    end
  end
end
