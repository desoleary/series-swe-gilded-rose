class GildedRose
  AGED_BRIE = "Aged Brie".freeze
  BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert".freeze
  SULFURAS = "Sulfuras, Hand of Ragnaros".freeze
  CONJURED = "Conjured Mana Cake".freeze
  LEGENDARY_ITEM_STATIC_QUALITY = 80.freeze
  LEGENDARY_ITEMS = [SULFURAS].freeze
  CONJURED_ITEMS = [CONJURED].freeze

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      original_item = item.dup
      if LEGENDARY_ITEMS.include?(item.name)
        item.quality = LEGENDARY_ITEM_STATIC_QUALITY
        next # sell_in never changes so no need to recalculate
      end

      if item.name != AGED_BRIE and item.name != BACKSTAGE_PASSES
        if item.quality > 0
          if item.name != SULFURAS
            item.quality = item.quality - 1
          end
        end
      else
        if item.quality < 50
          item.quality = item.quality + 1
          if item.name == BACKSTAGE_PASSES
            if item.sell_in < 11
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
            if item.sell_in < 6
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
          end
        end
      end
      if item.name != SULFURAS
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < 0
        if item.name != AGED_BRIE
          if item.name != BACKSTAGE_PASSES
            if item.quality > 0
              if item.name != SULFURAS
                item.quality = item.quality - 1
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
      end

      if CONJURED_ITEMS.include?(item.name)
        quality_delta = [original_item.quality - item.quality, 0].max
        item.quality = item.quality - quality_delta # double quality amount degraded
      end
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
