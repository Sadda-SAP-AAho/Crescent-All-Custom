@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Plan Data-Basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PRODPLANDATA_BASE 
  as select distinct from ZI_PRDPLANREGHD as a
    inner join            ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('01', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day1                                                              as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('02', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day2                                                              as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('03', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day3                                                              as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('04', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day4                                                              as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('05', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day5                                                              as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('06', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day6                                                              as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('07', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day7                                                              as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('08', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day8                                                              as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('09', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day9                                                              as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('10', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day10                                                              as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('11', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day11                                                              as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('12', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day12                                                             as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('13', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day13                                                              as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('14', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day14                                                              as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('15', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day15                                                             as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('16', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day16                                                             as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('17', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day17                                                            as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('18', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day18                                                              as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('19', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day19                                                              as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('20', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day20                                                             as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('21', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day21                                                             as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('22', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day22                                                             as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('23', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day23                                                             as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('24', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day24                                                             as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('25', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day25                                                             as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('26', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day26                                                             as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('27', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day27                                                             as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('28', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day28                                                             as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('29', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day29                                                             as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('30', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day30                                                             as Quantity

}

union all

select distinct from ZI_PRDPLANREGHD as a
  inner join         ZI_PRDPLANREGIT as b on a.Id = b.Id
{
  key a.Docnum,
  key a.Plantcode,
  key a.Prodyear,
  key a.Prodmonth,
  key b.Prodcode,
  key concat( concat('31', (case when a.Prodmonth = 'JANUARY' then '01'
            when a.Prodmonth = 'FEBRUARY' then '02'
            when a.Prodmonth = 'MARCH' then '03'
            when a.Prodmonth = 'APRIL' then '04'
            when a.Prodmonth = 'MAY' then '05'
            when a.Prodmonth = 'JUNE' then '06'
            when a.Prodmonth = 'JULY' then '07'
            when a.Prodmonth = 'AUGUST' then '08'
            when a.Prodmonth = 'SEPTEMBER' then '09'
            when a.Prodmonth = 'OCTOBER' then '10'
            when a.Prodmonth = 'NOVEMBER' then '11'
            when a.Prodmonth = 'DECEMBER' then '12' end ) ), a.Prodyear ) as Proddate,
      b.Day31                                                             as Quantity

}
