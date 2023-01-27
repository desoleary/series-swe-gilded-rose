# Gilded Rose Exercise

## Getting started

```shell
$ bundle
$ rspec gilded_rose_spec.rb
```

## Additional Recommended Enhancements
- Make GildedRose essentially a enumerable/collection class
- Possible enhancements
  - Handle case when given quality > 50 for non legendary items to set value to 50
  - Extract logic into individual action classes organized via organizer service class.
    - Pros included:
      - Improve testability and readability
      - Remove the insane amount of `nested if statements`
      - Adding extra functionality is as easy as adding another action
    - Introduce a service class that acts on single item classes E.g. `UpdateQualityOrganizer`
      - Create `DefaultUpdateQualityAction` that will be used to adjust the quality of an item based on the spec for normal items and returns adjusted item
      - Create `DefaultUpdateSellInAction` that will be used to adjust the `sellIn` of an item based on the spec for normal items and returns adjusted item
      - Create `NullUpdateSellInAction` that will not change the `sellIn` value
      - Create `LegendaryUpdateQualityAction` that will set the quality to 80
      - Create `AgedBrieQualityAction` that will increase instead of decrease quality
      - Create `BackstagePassesQualityAction` that will increase instead of decrease quality by 1X, 2X or 3X and when sellIn value is 0 set quality to `0`
      - Create `ConjuredQualityAction` that will double the amount to decrease per day
    - Inside `UpdateQualityOrganizer` Add logic to handle the different types by calling the appropriate actions
      - IF Legendary Item THEN UpdateQualityOrganizer => LegendaryUpdateQualityAction => NullUpdateSellInAction
      - IF AgedBrie Item THEN UpdateQualityOrganizer => AgedBrieQualityAction => DefaultUpdateSellInAction
      - IF Backstage Pass Item THEN UpdateQualityOrganizer => BackstagePassesQualityAction => DefaultUpdateSellInAction
      - IF Conjured Item THEN UpdateQualityOrganizer => ConjuredQualityAction => DefaultUpdateSellInAction
    - refactor specs into shared examples where possible
```ruby
  Default
```
- Simplify nested if statements 

```ruby






class DefaultItem < SimpleDelegator
  MIN_QUALITY = 0.freeze
  MAX_QUALITY = 50.freeze
  
  def initialize(item)
    super(item)
  end
  
  def quality=(quality)
    allowed_quality = [[quality, MIN_QUALITY].min, MAX_QUALITY].max
    @quality = allowed_quality
  end
end
```

```ruby
class LegendaryItem < DefaultItem
  MIN_QUALITY = 80.freeze
  MAX_QUALITY = 80.freeze

  def sell_in=(sell_in)
    raise ArgumentError 'sell in date for legendary items is not allowed'
  end
  
  def quality
    MAX_QUALITY # quality of legendary items must never change
  end
end
```


## Gilded Rose Requirements Specification

Hi and welcome to team Gilded Rose. As you know, we are a small inn with a prime location in a
prominent city ran by a friendly innkeeper named Allison. We also buy and sell only the finest goods.
Unfortunately, our goods are constantly degrading in quality as they approach their sell by date. We
have a system in place that updates our inventory for us. It was developed by a no-nonsense type named
Leeroy, who has moved on to new adventures. Your task is to add the new feature to our system so that
we can begin selling a new category of items. First an introduction to our system:

	- All items have a SellIn value which denotes the number of days we have to sell the item
	- All items have a Quality value which denotes how valuable the item is
	- At the end of each day our system lowers both values for every item

Pretty simple, right? Well this is where it gets interesting:

	- Once the sell by date has passed, Quality degrades twice as fast
	- The Quality of an item is never negative
	- "Aged Brie" actually increases in Quality the older it gets
	- The Quality of an item is never more than 50
	- "Sulfuras", being a legendary item, never has to be sold or decreases in Quality
	- "Backstage passes", like aged brie, increases in Quality as its SellIn value approaches;
	Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but
	Quality drops to 0 after the concert

We have recently signed a supplier of conjured items. This requires an update to our system:

	- "Conjured" items degrade in Quality twice as fast as normal items

Feel free to make any changes to the UpdateQuality method and add any new code as long as everything
still works correctly. However, do not alter the Item class or Items property as those belong to the
goblin in the corner who will insta-rage and one-shot you as he doesn't believe in shared code
ownership (you can make the UpdateQuality method and Items property static if you like, we'll cover
for you).

Just for clarification, an item can never have its Quality increase above 50, however "Sulfuras" is a
legendary item and as such its Quality is 80 and it never alters.
