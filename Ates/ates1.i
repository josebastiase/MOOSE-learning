[Mesh]
  [mesh]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 25
    ny = 25
    xmin = -800
    xmax = 800
    ymax = 1500
    ymin = -100
  []
[]

[Adaptivity]
  marker = marker
  max_h_level = 5
  [Indicators]
    [indicator]
      type = GradientJumpIndicator
      variable = temperature
    []
  []
  [Markers]
    [marker]
      type = ErrorFractionMarker
      indicator = indicator
      refine = .7
      coarsen = 0.1
    []
  []
[]

[GlobalParams]
  PorousFlowDictator = dictator
[]

# [ICs]
#   [porepressure]
#     type = FunctionIC
#     variable = porepressure
#     function = '40E4 - 0.05*y*1E4'
#   []
# []

[Variables]
  [porepressure]
    #scaling = 1E-11
  []
  [temperature]
    scaling = 1E-6
    initial_condition = 289
  []
[]

[PorousFlowFullySaturated]
  coupling_type = ThermoHydro
  #multiply_by_density = false
  porepressure = porepressure
  temperature = temperature
  fp = the_simple_fluid
  #stabilization = KT
[]

[Modules]
  [FluidProperties]
    [the_simple_fluid]
      type = SimpleFluidProperties
      bulk_modulus = 2E9
      thermal_expansion = 0.0002
      cp = 4194
      cv = 4186
      porepressure_coefficient = 0
      viscosity = 1E-3
      density0 = 1000.0
    []
  []
[]

[Functions]
  [mass_flux_in_fn]
    type = PiecewiseConstant
    direction = left
    xy_data = '
      0  2.5
      7776000 0
      31104000 2.5
      38880000 0
      62208000 2.5
      69984000 0
      93312000 2.5'
  []
  [mass_flux_in_cold_fn]
    type = PiecewiseConstant
    direction = left
    xy_data = '
      0  0
      15552000 2.5
      23328000 0
      46656000 2.5
      54432000 0
      77760000 2.5
      85536000 0'
  []
  [T_in_fn]
    type = PiecewiseLinear
    direction = left
    xy_data = '
      0    296'
  []
  [T_in_cold_fn]
    type = PiecewiseLinear
    direction = left
    xy_data = '
      0    282'
  []
  [ext_hot]
    type = ParsedFunction
    value = 'if(t >= 15552000 & t < 23328000, 1,
            if(t >= 46656000 & t < 54432000, 1,
            if(t >= 77760000 & t < 85536000, 1, 0)))'
  []
  [ext_cold]
    type = ParsedFunction
    value = 'if(t >= 31104000 & t < 38880000, 1,
            if(t >= 62208000 & t < 69984000, 1,
            if(t >= 93312000 & t < 101088000, 1, 0)))'
  []
[]

[DiracKernels]
  [source1]
    type = PorousFlowPointSourceFromPostprocessor
    variable = porepressure
    mass_flux = mass_flux_in
    point = '200 100 0'
  []
  [source2]
    type = PorousFlowPointSourceFromPostprocessor
    variable = porepressure
    mass_flux = mass_flux_in
    point = '250 100 0'
  []
  [source3]
    type = PorousFlowPointSourceFromPostprocessor
    variable = porepressure
    mass_flux = mass_flux_in_cold
    point = '-150 100 0'
  []
  [source4]
    type = PorousFlowPointSourceFromPostprocessor
    variable = porepressure
    mass_flux = mass_flux_in_cold
    point = '-100 100 0'
  []
  [source_h1]
    type = PorousFlowPointEnthalpySourceFromPostprocessor
    variable = temperature
    mass_flux = mass_flux_in
    point = '200 100 0'
    T_in = T_in
    pressure = porepressure
    fp = the_simple_fluid
  []
  [source_h2]
    type = PorousFlowPointEnthalpySourceFromPostprocessor
    variable = temperature
    mass_flux = mass_flux_in
    point = '250 100 0'
    T_in = T_in
    pressure = porepressure
    fp = the_simple_fluid
  []
  [source_h3]
    type = PorousFlowPointEnthalpySourceFromPostprocessor
    variable = temperature
    mass_flux = mass_flux_in_cold
    point = '-150 100 0'
    T_in = T_in_cold
    pressure = porepressure
    fp = the_simple_fluid
  []
  [source_h4]
    type = PorousFlowPointEnthalpySourceFromPostprocessor
    variable = temperature
    mass_flux = mass_flux_in_cold
    point = '-100 100 0'
    T_in = T_in_cold
    pressure = porepressure
    fp = the_simple_fluid
  []
  [produce_H2O_1]
    type = PorousFlowPeacemanBorehole
    variable = porepressure
    SumQuantityUO = produced_mass_H2O1
    mass_fraction_component = 0
    point_file = production1.bh
    line_length = 1
    bottom_p_or_t = 30E4
    unit_weight = '0 0 0'
    use_mobility = true
    character = 1
  []
  [remove_heat_at_production_well_1]
    type = PorousFlowPeacemanBorehole
    variable = temperature
    SumQuantityUO = produced_heat1
    point_file = production1.bh
    line_length = 1
    bottom_p_or_t = 30E4
    unit_weight = '0 0 0'
    use_mobility = true
    use_enthalpy = true
    character = 1
  []
  [produce_H2O_2]
    type = PorousFlowPeacemanBorehole
    variable = porepressure
    SumQuantityUO = produced_mass_H2O2
    mass_fraction_component = 0
    point_file = production2.bh
    line_length = 1
    bottom_p_or_t = 30E4
    unit_weight = '0 0 0'
    use_mobility = true
    character = 1
  []
  [remove_heat_at_production_well_2]
    type = PorousFlowPeacemanBorehole
    variable = temperature
    SumQuantityUO = produced_heat2
    point_file = production2.bh
    line_length = 1
    bottom_p_or_t = 30E4
    unit_weight = '0 0 0'
    use_mobility = true
    use_enthalpy = true
    character = 1
  []


  [produce_H2O_3]
    type = PorousFlowPeacemanBorehole
    variable = porepressure
    SumQuantityUO = produced_mass_H2O3
    mass_fraction_component = 0
    point_file = production3.bh
    line_length = 1
    bottom_p_or_t = 30E4
    unit_weight = '0 0 0'
    use_mobility = true
    character = 1
  []
  [remove_heat_at_production_well_3]
    type = PorousFlowPeacemanBorehole
    variable = temperature
    SumQuantityUO = produced_heat3
    point_file = production3.bh
    line_length = 1
    bottom_p_or_t = 30E4
    unit_weight = '0 0 0'
    use_mobility = true
    use_enthalpy = true
    character = 1
  []
  [produce_H2O_4]
    type = PorousFlowPeacemanBorehole
    variable = porepressure
    SumQuantityUO = produced_mass_H2O4
    mass_fraction_component = 0
    point_file = production4.bh
    line_length = 1
    bottom_p_or_t = 30E4
    unit_weight = '0 0 0'
    use_mobility = true
    character = 1
  []
  [remove_heat_at_production_well_4]
    type = PorousFlowPeacemanBorehole
    variable = temperature
    SumQuantityUO = produced_heat4
    point_file = production4.bh
    line_length = 1
    bottom_p_or_t = 30E4
    unit_weight = '0 0 0'
    use_mobility = true
    use_enthalpy = true
    character = 1
  []
[]

[UserObjects]
  [produced_mass_H2O1]
    type = PorousFlowSumQuantity
  []
  [produced_heat1]
    type = PorousFlowSumQuantity
  []
  [produced_mass_H2O2]
    type = PorousFlowSumQuantity
  []
  [produced_heat2]
    type = PorousFlowSumQuantity
  []

  [produced_mass_H2O3]
    type = PorousFlowSumQuantity
  []
  [produced_heat3]
    type = PorousFlowSumQuantity
  []
  [produced_mass_H2O4]
    type = PorousFlowSumQuantity
  []
  [produced_heat4]
    type = PorousFlowSumQuantity
  []
[]

[Controls]
  [produce_hot]
    type = ConditionalFunctionEnableControl
    enable_objects = 'DiracKernels::produce_H2O_1 DiracKernels::remove_heat_at_production_well_1 DiracKernels::produce_H2O_2 DiracKernels::remove_heat_at_production_well_2'
    conditional_function = ext_hot
    implicit = false
    execute_on = 'initial timestep_begin'
  []
  [produce_cold]
    type = ConditionalFunctionEnableControl
    enable_objects = 'DiracKernels::produce_H2O_3 DiracKernels::remove_heat_at_production_well_3 DiracKernels::produce_H2O_4 DiracKernels::remove_heat_at_production_well_4'
    conditional_function = ext_cold
    implicit = false
    execute_on = 'initial timestep_begin'
  []
[]

[BCs]
  [pp_bot]
    type = DirichletBC
    variable = porepressure
    value = 40E4
    boundary = bottom
  []
  [t_bot]
    type = DirichletBC
    variable = temperature
    value = 289
    boundary = bottom
  []
  [pp_top]
    type = DirichletBC
    variable = porepressure
    value = 25E4
    boundary = top
  []
  [t_top]
    type = PorousFlowOutflowBC
    boundary = top
    flux_type = heat
    variable = temperature
    gravity = '0 0 0'
  []
[]

[Materials]
  [porosity]
    type = PorousFlowPorosity
    porosity_zero = 0.1
  []
  [biot_modulus]
    type = PorousFlowConstantBiotModulus
    biot_coefficient = 1
    solid_bulk_compliance = 1E-8
    fluid_bulk_modulus = 2E9
  []
  [permeability_aquifer]
    type = PorousFlowPermeabilityConst
    permeability = '1E-10 0 0   0 1E-10 0   0 0 1E-9'
  []
  [thermal_expansion]
    type = PorousFlowConstantThermalExpansionCoefficient
    biot_coefficient = 1
    drained_coefficient = 0.003
    fluid_coefficient = 0.0002
  []
  [rock_internal_energy]
    type = PorousFlowMatrixInternalEnergy
    density = 2500.0
    specific_heat_capacity = 1200.0
  []
  [thermal_conductivity]
    type = PorousFlowThermalConductivityIdeal
    dry_thermal_conductivity = '2 0 0  0 2 0  0 0 1E-3'
  []
[]

[Preconditioning]
  active = lu
  [basic]
    type = SMP
    full = true
    petsc_options = '-ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = ' asm      lu           NONZERO                   2'
  []
  [lu]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = ' lu       mumps'
  []
[]

[Postprocessors]
  [total_mass]
    type = PorousFlowFluidMass
    execute_on = 'initial timestep_end'
  []

  [total_heat]
    type = PorousFlowHeatEnergy
  []

  [mass_flux_in]
    type = FunctionValuePostprocessor
    function = mass_flux_in_fn
    execute_on = 'initial timestep_end'
  []

  [mass_flux_in_cold]
    type = FunctionValuePostprocessor
    function = mass_flux_in_cold_fn
    execute_on = 'initial timestep_end'
  []

  [avg_temp]
    type = ElementAverageValue
    variable = temperature
    execute_on = 'initial timestep_end'
  []

  [T_in]
    type = FunctionValuePostprocessor
    function = T_in_fn
    execute_on = 'initial timestep_end'
  []

  [T_in_cold]
    type = FunctionValuePostprocessor
    function = T_in_cold_fn
    execute_on = 'initial timestep_end'
  []
[]

[Executioner]
  type = Transient
  solve_type = Newton
  end_time = 93312000#720000
  dt = 432000#3600#6E-2
  nl_abs_tol = 1E-8
  #dtmax = 5000
  # [TimeStepper]
  #   type = IterationAdaptiveDT
  #   dt = 1
  #   growth_factor = 1.1
  # []
[]


[Outputs]
  exodus = true
  csv = true
  file_base = gold/ates1
[]
