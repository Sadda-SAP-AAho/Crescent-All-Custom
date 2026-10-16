@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View for Production Plan Reg-Item'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZC_PRDPLANREGIT
  as projection on ZI_PRDPLANREGIT
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Product Code'
      Prodcode,
      @EndUserText.label: 'Product Name'
      Prodname,
      @EndUserText.label: 'Day 1'
      Day1,
      @EndUserText.label: 'Day 2'
      Day2,
      @EndUserText.label: 'Day 3'
      Day3,
      @EndUserText.label: 'Day 4'
      Day4,
      @EndUserText.label: 'Day 5'
      Day5,
      @EndUserText.label: 'Day 6'
      Day6,
      @EndUserText.label: 'Day 7'
      Day7,
      @EndUserText.label: 'Day 8'
      Day8,
      @EndUserText.label: 'Day 9'
      Day9,
      @EndUserText.label: 'Day 10'
      Day10,
      @EndUserText.label: 'Day 11'
      Day11,
      @EndUserText.label: 'Day 12'
      Day12,
      @EndUserText.label: 'Day 13'
      Day13,
      @EndUserText.label: 'Day 14'
      Day14,
      @EndUserText.label: 'Day 15'
      Day15,
      @EndUserText.label: 'Day 16'
      Day16,
      @EndUserText.label: 'Day 17'
      Day17,
      @EndUserText.label: 'Day 18'
      Day18,
      @EndUserText.label: 'Day 19'
      Day19,
      @EndUserText.label: 'Day 20'
      Day20,
      @EndUserText.label: 'Day 21'
      Day21,
      @EndUserText.label: 'Day 22'
      Day22,
      @EndUserText.label: 'Day 23'
      Day23,
      @EndUserText.label: 'Day 24'
      Day24,
      @EndUserText.label: 'Day 25'
      Day25,
      @EndUserText.label: 'Day 26'
      Day26,
      @EndUserText.label: 'Day 27'
      Day27,
      @EndUserText.label: 'Day 28'
      Day28,
      @EndUserText.label: 'Day 29'
      Day29,
      @EndUserText.label: 'Day 30'
      Day30,
      @EndUserText.label: 'Day 31'
      Day31,
      /* Associations */
      _Head : redirected to parent ZC_PRDPLANREGHD
}
