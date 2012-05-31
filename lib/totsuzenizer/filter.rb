# -*- coding: utf-8 -*-
require 'okura/serializer'
module Totsuzenizer
  class Filter

    def initialize(dict_dir)
      @dict_dir = dict_dir
    end

    def totsuzenize(text)
      words = parse(text)
      words = words.select { |e| e.surface != "BOS/EOS"}

      index = 0
      while ! words.empty?
        if match?(words)
          ret =  words.map{|w|w.surface}.join + T::TOTSUZENSHI_AA
          return ret
        end
        words.pop
      end

      return
    end

    private

    def patterns
      [["名詞","助詞"]]
    end

    #wordsの末尾がマッチするかチェック
    def match?(words)
      word_classes = words.map{|w| w.left.text.split(',')[0]}
      patterns.each do |pat|
        next if pat.size > word_classes.size
        return true if pat == word_classes.last(pat.size)
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
