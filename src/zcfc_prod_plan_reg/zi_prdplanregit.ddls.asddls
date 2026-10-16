@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View for Production Plan Reg-Item'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L

define view entity ZI_PRDPLANREGIT
  as select from zdt_prdplanregit
  association to parent ZI_PRDPLANREGHD as _Head on $projection.Id = _Head.Id
{
  key zdt_prdplanregit.id       as Id,
  key zdt_prdplanregit.item     as Item,
      zdt_prdplanregit.prodcode as Prodcode,
      zdt_prdplanregit.prodname as Prodname,
      zdt_prdplanregit.day1     as Day1,
      zdt_prdplanregit.day2     as Day2,
      zdt_prdplanregit.day3     as Day3,
      zdt_prdplanregit.day4     as Day4,
      zdt_prdplanregit.day5     as Day5,
      zdt_prdplanregit.day6     as Day6,
      zdt_prdplanregit.day7     as Day7,
      zdt_prdplanregit.day8     as Day8,
      zdt_prdplanregit.day9     as Day9,
      zdt_prdplanregit.day10    as Day10,
      zdt_prdplanregit.day11    as Day11,
      zdt_prdplanregit.day12    as Day12,
      zdt_prdplanregit.day13    as Day13,
      zdt_prdplanregit.day14    as Day14,
      zdt_prdplanregit.day15    as Day15,
      zdt_prdplanregit.day16    as Day16,
      zdt_prdplanregit.day17    as Day17,
      zdt_prdplanregit.day18    as Day18,
      zdt_prdplanregit.day19    as Day19,
      zdt_prdplanregit.day20    as Day20,
      zdt_prdplanregit.day21    as Day21,
      zdt_prdplanregit.day22    as Day22,
      zdt_prdplanregit.day23    as Day23,
      zdt_prdplanregit.day24    as Day24,
      zdt_prdplanregit.day25    as Day25,
      zdt_prdplanregit.day26    as Day26,
      zdt_prdplanregit.day27    as Day27,
      zdt_prdplanregit.day28    as Day28,
      zdt_prdplanregit.day29    as Day29,
      zdt_prdplanregit.day30    as Day30,
      zdt_prdplanregit.day31    as Day31,
      _Head
}
