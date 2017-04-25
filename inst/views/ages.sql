
-- Code generated by `create_age_query.R`
-- Edit that file instead

create or replace algorithm = undefined view backend.q_Task_Ages as
  select
    ChildStudyID,
    "LENA" as Task,
    LENA_Date as Task_Completion,
    LENA_Age as Task_Age
  from
    backend.LENA_Admin
  union all
    select
      ChildStudyID,
      "Blending" as Task,
      Blending_Completion as Task_Completion,
      Blending_Age as Task_Age
    from
      backend.Blending_Admin
  union all
    select
      ChildStudyID,
      "BRIEF" as Task,
      BRIEF_Completion as Task_Completion,
      BRIEF_Age as Task_Age
    from
      backend.BRIEF
  union all
    select
      ChildStudyID,
      "CTOPP_Blending" as Task,
      CTOPP_Blending_Completion as Task_Completion,
      CTOPP_Blending_Age as Task_Age
    from
      backend.CTOPP_Blending
  union all
    select
      ChildStudyID,
      "CTOPP_Elision" as Task,
      CTOPP_Elision_Completion as Task_Completion,
      CTOPP_Elision_Age as Task_Age
    from
      backend.CTOPP_Elision
  union all
    select
      ChildStudyID,
      "CTOPP_Memory" as Task,
      CTOPP_Memory_Completion as Task_Completion,
      CTOPP_Memory_Age as Task_Age
    from
      backend.CTOPP_Memory
  union all
    select
      ChildStudyID,
      "DELV_Risk" as Task,
      DELV_Risk_Completion as Task_Completion,
      DELV_Risk_Age as Task_Age
    from
      backend.DELV_Risk
  union all
    select
      ChildStudyID,
      "DELV_Variation" as Task,
      DELV_Variation_Completion as Task_Completion,
      DELV_Variation_Age as Task_Age
    from
      backend.DELV_Variation
  union all
    select
      ChildStudyID,
      "EVT" as Task,
      EVT_Completion as Task_Completion,
      EVT_Age as Task_Age
    from
      backend.EVT
  union all
    select
      ChildStudyID,
      "FruitStroop" as Task,
      FruitStroop_Completion as Task_Completion,
      FruitStroop_Age as Task_Age
    from
      backend.FruitStroop
  union all
    select
      ChildStudyID,
      "GFTA" as Task,
      GFTA_Completion as Task_Completion,
      GFTA_Age as Task_Age
    from
      backend.GFTA
  union all
    select
      ChildStudyID,
      "KBIT" as Task,
      KBIT_Completion as Task_Completion,
      KBIT_Age as Task_Age
    from
      backend.KBIT
  union all
    select
      ChildStudyID,
      "MinPair" as Task,
      MinPair_Completion as Task_Completion,
      MinPair_Age as Task_Age
    from
      backend.MinPair_Admin
  union all
    select
      ChildStudyID,
      "PPVT" as Task,
      PPVT_Completion as Task_Completion,
      PPVT_Age as Task_Age
    from
      backend.PPVT
  union all
    select
      ChildStudyID,
      "RealWordRep" as Task,
      RealWordRep_Completion as Task_Completion,
      RealWordRep_Age as Task_Age
    from
      backend.RealWordRep_Admin
  union all
    select
      ChildStudyID,
      "Rhyming" as Task,
      Rhyming_Completion as Task_Completion,
      Rhyming_Age as Task_Age
    from
      backend.Rhyming_Admin
  union all
    select
      ChildStudyID,
      "SAILS" as Task,
      SAILS_Completion as Task_Completion,
      SAILS_Age as Task_Age
    from
      backend.SAILS_Admin
  union all
    select
      ChildStudyID,
      "VerbalFluency" as Task,
      VerbalFluency_Completion as Task_Completion,
      VerbalFluency_Age as Task_Age
    from
      backend.VerbalFluency