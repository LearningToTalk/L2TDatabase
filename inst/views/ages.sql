
-- Code generated by `create_age_query.R`
-- Edit that file instead

create or replace algorithm = undefined view l2t.Task_Ages as
  select
    Study,
    ResearchID,
    "EVT" as Task,
    EVT_Completion as TaskDate,
    EVT_Age as TaskAge
  from
    l2t.EVT
  union all
    select
      Study,
      ResearchID,
      "Blending" as Task,
      Blending_Completion as TaskDate,
      Blending_Age as TaskAge
    from
      l2t.Blending_Summary
  union all
    select
      Study,
      ResearchID,
      "BRIEF" as Task,
      BRIEF_Completion as TaskDate,
      BRIEF_Age as TaskAge
    from
      l2t.BRIEF
  union all
    select
      Study,
      ResearchID,
      "CTOPP_Blending" as Task,
      CTOPP_Blending_Completion as TaskDate,
      CTOPP_Blending_Age as TaskAge
    from
      l2t.CTOPP_Blending
  union all
    select
      Study,
      ResearchID,
      "CTOPP_Elision" as Task,
      CTOPP_Elision_Completion as TaskDate,
      CTOPP_Elision_Age as TaskAge
    from
      l2t.CTOPP_Elision
  union all
    select
      Study,
      ResearchID,
      "CTOPP_Memory" as Task,
      CTOPP_Memory_Completion as TaskDate,
      CTOPP_Memory_Age as TaskAge
    from
      l2t.CTOPP_Memory
  union all
    select
      Study,
      ResearchID,
      "DELV_Risk" as Task,
      DELV_Risk_Completion as TaskDate,
      DELV_Risk_Age as TaskAge
    from
      l2t.DELV_Risk
  union all
    select
      Study,
      ResearchID,
      "FruitStroop" as Task,
      FruitStroop_Completion as TaskDate,
      FruitStroop_Age as TaskAge
    from
      l2t.FruitStroop
  union all
    select
      Study,
      ResearchID,
      "GFTA" as Task,
      GFTA_Completion as TaskDate,
      GFTA_Age as TaskAge
    from
      l2t.GFTA
  union all
    select
      Study,
      ResearchID,
      "KBIT" as Task,
      KBIT_Completion as TaskDate,
      KBIT_Age as TaskAge
    from
      l2t.KBIT
  union all
    select
      Study,
      ResearchID,
      "LENA" as Task,
      LENA_Completion as TaskDate,
      LENA_Age as TaskAge
    from
      l2t.LENA_Averages
  union all
    select
      Study,
      ResearchID,
      "MinPair" as Task,
      MinPair_Completion as TaskDate,
      MinPair_Age as TaskAge
    from
      l2t.MinPair_Aggregate
  union all
    select
      Study,
      ResearchID,
      "PPVT" as Task,
      PPVT_Completion as TaskDate,
      PPVT_Age as TaskAge
    from
      l2t.PPVT
  union all
    select
      Study,
      ResearchID,
      "Rhyming" as Task,
      Rhyming_Completion as TaskDate,
      Rhyming_Age as TaskAge
    from
      l2t.Rhyming_Aggregate
  union all
    select
      Study,
      ResearchID,
      "SAILS" as Task,
      SAILS_Completion as TaskDate,
      SAILS_Age as TaskAge
    from
      l2t.SAILS_Aggregate
  union all
    select
      Study,
      ResearchID,
      "VerbalFluency" as Task,
      VerbalFluency_Completion as TaskDate,
      VerbalFluency_Age as TaskAge
    from
      l2t.VerbalFluency
