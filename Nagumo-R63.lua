local PartCreator = {}

local Function = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")


function run(Player)
	local Camera = workspace.CurrentCamera

	local IS = game:GetService("InsertService")

	local Spring



	if RunService:IsStudio() then
		Spring = require(script.Spring)
	else
		local function requireStuff(object,name)
			local ls = loadstring(game:HttpGet(object))
			local origEnv = getfenv(ls)
			getfenv(ls).script = name
			getfenv(ls).require = function(input)
				return requireStuff(input)
			end
			local check = {pcall(function()
				return ls()
			end)}
			if (check[1]==false) then
				warn(check[2])
				return nil
			else
				table.remove(check,1)
				return unpack(check)
			end
		end

		Spring = requireStuff("https://raw.githubusercontent.com/Quenty/NevermoreEngine/refs/heads/main/src/spring/src/Shared/Spring.lua","Spring")
	end


	local SelectPlayer = Player.Name

	local PositionPhysicsMultiply = 1
	local RotationPhysicsMultiply = 4


	function Function.PartListDefault()	
		return {
			ClemonFemale = {
				Limbs = {
					["Left Leg"] = {
						["Instance"] = "Mesh",
						["MeshId"] = "rbxassetid://6870651596",
						["Function"] = {},
						["Transparency"] = 0,
						["Name"] = "Left Leg",
						["Parent"] = {
							[1] = "Left Leg"
						},
						["Joint"] = {
							["Part0"] = "Left Leg",
							["CFrame"] = {
								["Rotation"] = {
									["y"] = 90.00000933466734,
									["x"] = -0,
									["z"] = 0
								},
								["Position"] = {
									["y"] = 0.12550246715545654,
									["x"] = -0.03792572021484375,
									["z"] = 0.01025390625
								}
							},
							["CFrame1"] = {
								["Rotation"] = {
									["y"] = 0,
									["x"] = -0,
									["z"] = 0
								},
								["Position"] = {
									["y"] = 0,
									["x"] = 0,
									["z"] = 0
								}
							}
						},
						["Material"] = Enum.Material.SmoothPlastic,
						["Shape"] = Enum.PartType.Block,
						["Size"] = {
							["y"] = 2.292320728302002,
							["x"] = 1.087515950202942,
							["z"] = 1.2521870136260986
						}
					},
					["Right Leg"] = {
						["Instance"] = "Mesh",
						["MeshId"] = "rbxassetid://6870651384",
						["Function"] = {},
						["Transparency"] = 0,
						["Name"] = "Right Leg",
						["Parent"] = {
							[1] = "Right Leg"
						},
						["Joint"] = {
							["Part0"] = "Right Leg",
							["CFrame"] = {
								["Rotation"] = {
									["y"] = 90.00000933466734,
									["x"] = -0,
									["z"] = 0
								},
								["Position"] = {
									["y"] = 0.12545979022979736,
									["x"] = 0.048073768615722656,
									["z"] = 0.0102691650390625
								}
							},
							["CFrame1"] = {
								["Rotation"] = {
									["y"] = 0,
									["x"] = -0,
									["z"] = 0
								},
								["Position"] = {
									["y"] = 0,
									["x"] = 0,
									["z"] = 0
								}
							}
						},
						["Material"] = Enum.Material.SmoothPlastic,
						["Shape"] = Enum.PartType.Block,
						["Size"] = {
							["y"] = 2.292334794998169,
							["x"] = 1.0879312753677368,
							["z"] = 1.207716941833496
						}
					},

					["Left Leg UV"] = {
						["Instance"] = "Mesh",
						["MeshId"] = "rbxassetid://6870651596",
						["Function"] = {},
						["Transparency"] = 1,
						["Name"] = "Left Leg UV",
						["Parent"] = {
							[1] = "Left Leg",
							[2] = "Left Leg"
						},
						["Joint"] = {
							["Part0"] = "Left Leg",
							["CFrame"] = {
								["Rotation"] = {
									["y"] = 0,
									["x"] = -0,
									["z"] = 0
								},
								["Position"] = {
									["y"] = 0,
									["x"] = 0,
									["z"] = 0
								}
							},
							["CFrame1"] = {
								["Rotation"] = {
									["y"] = 0,
									["x"] = -0,
									["z"] = 0
								},
								["Position"] = {
									["y"] = 0,
									["x"] = 0,
									["z"] = 0
								}
							}
						},
						["Material"] = Enum.Material.SmoothPlastic,
						["Shape"] = Enum.PartType.Block,
						["Size"] = {
							["y"] = 2.292320728302002,
							["x"] = 1.087515950202942,
							["z"] = 1.2521870136260986
						}
					},
					["Right Leg UV"] = {
						["Instance"] = "Mesh",
						["MeshId"] = "rbxassetid://6870651384",
						["Function"] = {},
						["Transparency"] = 1,
						["Name"] = "Right Leg UV",
						["Parent"] = {
							[1] = "Right Leg",
							[2] = "Right Leg"
						},
						["Joint"] = {
							["Part0"] = "Right Leg",
							["CFrame"] = {
								["Rotation"] = {
									["y"] = 0,
									["x"] = -0,
									["z"] = 0
								},
								["Position"] = {
									["y"] = 0,
									["x"] = 0,
									["z"] = 0
								}
							},
							["CFrame1"] = {
								["Rotation"] = {
									["y"] = 0,
									["x"] = -0,
									["z"] = 0
								},
								["Position"] = {
									["y"] = 0,
									["x"] = 0,
									["z"] = 0
								}
							}
						},
						["Material"] = Enum.Material.SmoothPlastic,
						["Shape"] = Enum.PartType.Block,
						["Size"] = {
							["y"] = 2.292334794998169,
							["x"] = 1.0879312753677368,
							["z"] = 1.207716941833496
						}
					},
					["TorsoMesh"] = {
						["Instance"] = "Mesh",
						["MeshId"] = "rbxassetid://13755434958",
						["Color"] = "Base",
						["Function"] = {},
						["Transparency"] = 1,
						["Name"] = "TorsoMesh",
						["Parent"] = {
							[1] = "Torso"
						},
						["Joint"] = {
							["Part0"] = "Torso",
							["CFrame"] = {
								["Rotation"] = {
									["y"] = 179.999991348578,
									["x"] = -6.362426808311495e-10,
									["z"] = -0.00009387990064223813
								},
								["Position"] = {
									["y"] = 0.05200004577636719,
									["x"] = 0,
									["z"] = 0
								}
							},
							["CFrame1"] = {
								["Rotation"] = {
									["y"] = 0,
									["x"] = -0,
									["z"] = 0
								},
								["Position"] = {
									["y"] = 0,
									["x"] = 0,
									["z"] = 0
								}
							}
						},
						["Material"] = Enum.Material.SmoothPlastic,
						["Shape"] = Enum.PartType.Block,
						["Size"] = {
							["y"] = 1.998084545135498,
							["x"] = 2.077857255935669,
							["z"] = 0.966502845287323
						}
					},
				},
				Vaginas = {
					Closed = {
						["[A] Vagina"] = {
							["Instance"] = "Part",
							["Color"] = 0.9973507482925269,
							["Parent"] = {
								[1] = "Closed"
							},
							["Function"] = {},
							["Transparency"] = 0,
							["Name"] = "[A] Vagina",
							["Mesh"] = {
								["Scale"] = {
									["y"] = 1.0099999904632568,
									["x"] = 0.20000000298023224,
									["z"] = 1.0099999904632568
								},
								["MeshId"] = "",
								["MeshType"] = Enum.MeshType.Sphere,
								["TextureId"] = ""
							},
							["Joint"] = {
								["Part0"] = "Closed",
								["CFrame"] = {
									["Rotation"] = {
										["y"] = 0.00010906826101211563,
										["x"] = -64.00065520239285,
										["z"] = 179.99988206555128
									},
									["Position"] = {
										["y"] = -1.1307519674301147,
										["x"] = -0.0013651847839355469,
										["z"] = -0.07950592041015625
									}
								},
								["CFrame1"] = {
									["Rotation"] = {
										["y"] = 0,
										["x"] = -0,
										["z"] = 0
									},
									["Position"] = {
										["y"] = 0,
										["x"] = 0,
										["z"] = 0
									}
								}
							},
							["Material"] = Enum.Material.SmoothPlastic,
							["Shape"] = Enum.PartType.Block,
							["Size"] = {
								["y"] = 0.6525917053222656,
								["x"] = 0.4109848141670227,
								["z"] = 0.452888548374176
							}
						},
						["[Skin] Majora R"] = {
							["Instance"] = "Part",
							["Color"] = "Base",
							["Parent"] = {
								[1] = "Closed"
							},
							["Function"] = {},
							["Transparency"] = 0,
							["Name"] = "[Skin] Majora R",
							["Mesh"] = {
								["Scale"] = {
									["y"] = 1,
									["x"] = 0.6000000238418579,
									["z"] = 1
								},
								["MeshId"] = "",
								["MeshType"] = Enum.MeshType.Sphere,
								["TextureId"] = ""
							},
							["Joint"] = {
								["Part0"] = "Closed",
								["CFrame"] = {
									["Rotation"] = {
										["y"] = -10.699208735748066,
										["x"] = -59.41658740131713,
										["z"] = -171.21645003821163
									},
									["Position"] = {
										["y"] = -1.100150465965271,
										["x"] = 0.10254335403442383,
										["z"] = -0.05848121643066406
									}
								},
								["CFrame1"] = {
									["Rotation"] = {
										["y"] = 0,
										["x"] = -0,
										["z"] = 0
									},
									["Position"] = {
										["y"] = 0,
										["x"] = 0,
										["z"] = 0
									}
								}
							},
							["Material"] = Enum.Material.SmoothPlastic,
							["Shape"] = Enum.PartType.Block,
							["Size"] = {
								["y"] = 0.7530205249786377,
								["x"] = 0.7523967027664185,
								["z"] = 0.5753535628318787
							}
						},
						["[Skin] Majora A.1"] = {
							["Instance"] = "Part",
							["Color"] = 0.9973507482925269,
							["Parent"] = {
								[1] = "Closed"
							},
							["Function"] = {},
							["Transparency"] = 0,
							["Name"] = "[Skin] Majora A.1",
							["Mesh"] = {
								["Scale"] = {
									["y"] = 1,
									["x"] = 0.6000000238418579,
									["z"] = 1
								},
								["MeshId"] = "",
								["MeshType"] = Enum.MeshType.Sphere,
								["TextureId"] = ""
							},
							["Joint"] = {
								["Part0"] = "Closed",
								["CFrame"] = {
									["Rotation"] = {
										["y"] = 68.46451850426551,
										["x"] = -84.17179525551711,
										["z"] = 112.09061012948361
									},
									["Position"] = {
										["y"] = -1.2834436893463135,
										["x"] = 0.011543750762939453,
										["z"] = 0.3380546569824219
									}
								},
								["CFrame1"] = {
									["Rotation"] = {
										["y"] = 0,
										["x"] = -0,
										["z"] = 0
									},
									["Position"] = {
										["y"] = 0,
										["x"] = 0,
										["z"] = 0
									}
								}
							},
							["Material"] = Enum.Material.SmoothPlastic,
							["Shape"] = Enum.PartType.Block,
							["Size"] = {
								["y"] = 0.15872108936309814,
								["x"] = 0.08978316932916641,
								["z"] = 0.24876534938812256
							}
						},
						["[B] Vulva.1"] = {
							["Instance"] = "Part",
							["Color"] = 0.9973507482925269,
							["Parent"] = {
								[1] = "Closed"
							},
							["Function"] = {},
							["Transparency"] = 0,
							["Name"] = "[B] Vulva.1",
							["Mesh"] = {
								["Scale"] = {
									["y"] = 1,
									["x"] = 0.3559962213039398,
									["z"] = 1
								},
								["MeshId"] = "",
								["MeshType"] = Enum.MeshType.Sphere,
								["TextureId"] = ""
							},
							["Joint"] = {
								["Part0"] = "Closed",
								["CFrame"] = {
									["Rotation"] = {
										["y"] = 0.0002534274959200993,
										["x"] = -64.00079863636542,
										["z"] = 179.99974546176787
									},
									["Position"] = {
										["y"] = -1.130752444267273,
										["x"] = -0.0013651847839355469,
										["z"] = -0.07950592041015625
									}
								},
								["CFrame1"] = {
									["Rotation"] = {
										["y"] = 0,
										["x"] = -0,
										["z"] = 0
									},
									["Position"] = {
										["y"] = 0,
										["x"] = 0,
										["z"] = 0
									}
								}
							},
							["Material"] = Enum.Material.SmoothPlastic,
							["Shape"] = Enum.PartType.Block,
							["Size"] = {
								["y"] = 0.6525917053222656,
								["x"] = 0.4109848141670227,
								["z"] = 0.452888548374176
							}
						},
						["[B] Clitoris"] = {
							["Instance"] = "Part",
							["Color"] = 0.9973507482925269,
							["Parent"] = {
								[1] = "Closed"
							},
							["Function"] = {},
							["Transparency"] = 0,
							["Name"] = "[B] Clitoris",
							["Mesh"] = {
								["Scale"] = {
									["y"] = 0.10383700579404831,
									["x"] = 0.0699358657002449,
									["z"] = 0.5085670948028564
								},
								["MeshId"] = "",
								["MeshType"] = Enum.MeshType.Sphere,
								["TextureId"] = ""
							},
							["Joint"] = {
								["Part0"] = "Closed",
								["CFrame"] = {
									["Rotation"] = {
										["y"] = -0.00068733999966085,
										["x"] = -50.2111179851624,
										["z"] = -179.99933565041766
									},
									["Position"] = {
										["y"] = -0.9790191650390625,
										["x"] = -0.0013995170593261719,
										["z"] = -0.34190940856933594
									}
								},
								["CFrame1"] = {
									["Rotation"] = {
										["y"] = 0,
										["x"] = -0,
										["z"] = 0
									},
									["Position"] = {
										["y"] = 0,
										["x"] = 0,
										["z"] = 0
									}
								}
							},
							["Material"] = Enum.Material.SmoothPlastic,
							["Shape"] = Enum.PartType.Block,
							["Size"] = {
								["y"] = 0.4109853506088257,
								["x"] = 0.4109848141670227,
								["z"] = 0.4109854996204376
							}
						},
						["[B] Clitoris.1"] = {
							["Instance"] = "Part",
							["Color"] = 0.9973507482925269,
							["Parent"] = {
								[1] = "Closed"
							},
							["Function"] = {},
							["Transparency"] = 0,
							["Name"] = "[B] Clitoris.1",
							["Mesh"] = {
								["Scale"] = {
									["y"] = 0.1970651000738144,
									["x"] = 0.18858975172042847,
									["z"] = 0.36024942994117737
								},
								["MeshId"] = "",
								["MeshType"] = Enum.MeshType.Sphere,
								["TextureId"] = ""
							},
							["Joint"] = {
								["Part0"] = "Closed",
								["CFrame"] = {
									["Rotation"] = {
										["y"] = -0.0007886732493942861,
										["x"] = -55.21145166520455,
										["z"] = -179.99925368814763
									},
									["Position"] = {
										["y"] = -0.9779143333435059,
										["x"] = -0.0013995170593261719,
										["z"] = -0.3583049774169922
									}
								},
								["CFrame1"] = {
									["Rotation"] = {
										["y"] = 0,
										["x"] = -0,
										["z"] = 0
									},
									["Position"] = {
										["y"] = 0,
										["x"] = 0,
										["z"] = 0
									}
								}
							},
							["Material"] = Enum.Material.SmoothPlastic,
							["Shape"] = Enum.PartType.Block,
							["Size"] = {
								["y"] = 0.4109853506088257,
								["x"] = 0.4109848141670227,
								["z"] = 0.4109854996204376
							}
						},
						["[Skin] Majora L"] = {
							["Instance"] = "Part",
							["Color"] = "Base",
							["Parent"] = {
								[1] = "Closed"
							},
							["Function"] = {},
							["Transparency"] = 0,
							["Name"] = "[Skin] Majora L",
							["Mesh"] = {
								["Scale"] = {
									["y"] = 1,
									["x"] = 0.6000000238418579,
									["z"] = 1
								},
								["MeshId"] = "",
								["MeshType"] = Enum.MeshType.Sphere,
								["TextureId"] = ""
							},
							["Joint"] = {
								["Part0"] = "Closed",
								["CFrame"] = {
									["Rotation"] = {
										["y"] = 10.699028589508705,
										["x"] = -59.415979514481,
										["z"] = 171.21528890605273
									},
									["Position"] = {
										["y"] = -1.1000949144363403,
										["x"] = -0.1044764518737793,
										["z"] = -0.05852699279785156
									}
								},
								["CFrame1"] = {
									["Rotation"] = {
										["y"] = 0,
										["x"] = -0,
										["z"] = 0
									},
									["Position"] = {
										["y"] = 0,
										["x"] = 0,
										["z"] = 0
									}
								}
							},
							["Material"] = Enum.Material.SmoothPlastic,
							["Shape"] = Enum.PartType.Block,
							["Size"] = {
								["y"] = 0.7530205249786377,
								["x"] = 0.7523967027664185,
								["z"] = 0.5753535628318787
							}
						},
						["[B] Vulva"] = {
							["Instance"] = "Part",
							["Color"] = 0.9973507482925269,
							["Parent"] = {
								[1] = "Closed"
							},
							["Function"] = {},
							["Transparency"] = 0,
							["Name"] = "[B] Vulva",
							["Mesh"] = {
								["Scale"] = {
									["y"] = 0.8546401262283325,
									["x"] = 0.26065924763679504,
									["z"] = 0.5411533117294312
								},
								["MeshId"] = "",
								["MeshType"] = Enum.MeshType.Sphere,
								["TextureId"] = ""
							},
							["Joint"] = {
								["Part0"] = "Closed",
								["CFrame"] = {
									["Rotation"] = {
										["y"] = 0.00010423260307706939,
										["x"] = -33.99818183908725,
										["z"] = 179.99986840517292
									},
									["Position"] = {
										["y"] = -1.104068398475647,
										["x"] = -0.0013728141784667969,
										["z"] = -0.2517814636230469
									}
								},
								["CFrame1"] = {
									["Rotation"] = {
										["y"] = 0,
										["x"] = -0,
										["z"] = 0
									},
									["Position"] = {
										["y"] = 0,
										["x"] = 0,
										["z"] = 0
									}
								}
							},
							["Material"] = Enum.Material.SmoothPlastic,
							["Shape"] = Enum.PartType.Block,
							["Size"] = {
								["y"] = 0.4109853506088257,
								["x"] = 0.4109848141670227,
								["z"] = 0.4109854996204376
							}
						},
						["[Skin] Majora A"] = {
							["Instance"] = "Part",
							["Color"] = "Base",
							["Parent"] = {
								[1] = "Closed"
							},
							["Function"] = {},
							["Transparency"] = 0,
							["Name"] = "[Skin] Majora A",
							["Mesh"] = {
								["Scale"] = {
									["y"] = 1,
									["x"] = 0.6000000238418579,
									["z"] = 1
								},
								["MeshId"] = "",
								["MeshType"] = Enum.MeshType.Sphere,
								["TextureId"] = ""
							},
							["Joint"] = {
								["Part0"] = "Closed",
								["CFrame"] = {
									["Rotation"] = {
										["y"] = 10.699040542339754,
										["x"] = -59.41596585410266,
										["z"] = 171.21528890605273
									},
									["Position"] = {
										["y"] = -1.1533641815185547,
										["x"] = 0.014851093292236328,
										["z"] = 0.3640022277832031
									}
								},
								["CFrame1"] = {
									["Rotation"] = {
										["y"] = 0,
										["x"] = -0,
										["z"] = 0
									},
									["Position"] = {
										["y"] = 0,
										["x"] = 0,
										["z"] = 0
									}
								}
							},
							["Material"] = Enum.Material.SmoothPlastic,
							["Shape"] = Enum.PartType.Block,
							["Size"] = {
								["y"] = 0.33889174461364746,
								["x"] = 0.5523967146873474,
								["z"] = 0.5363864898681641
							}
						}
					} 
				},
				Breasts = {
					["BreastsRoot"] = {
						["Instance"] = "Part",
						["Color"] = "Base",
						["Function"] = {"BreastUVPhysics"},
						["Transparency"] = 1,
						["Name"] = "BreastsRoot",
						["Parent"] = {
							[1] = "Torso"
						},
						["Joint"] = {
							["Part0"] = "Torso",
							["CFrame"] = {
								["Rotation"] = {
									["y"] = -0.00001366099063496834,
									["x"] = -0.0000034158497759099423,
									["z"] = 0.00003756666575756494
								},
								["Position"] = {
									["y"] = 0.9002821445465088,
									["x"] = 0.000015735626220703125,
									["z"] = -0.30001163482666016
								}
							},
							["CFrame1"] = {
								["Rotation"] = {
									["y"] = -3.2406041899604844e-08,
									["x"] = -0.00016904969627534681,
									["z"] = -1.2819104782560808e-08
								},
								["Position"] = {
									["y"] = -0.016043663024902344,
									["x"] = 4.76837158203125e-07,
									["z"] = -9.5367431640625e-07
								}
							}
						},
						["Material"] = Enum.Material.Plastic,
						["Shape"] = Enum.PartType.Block,
						["Size"] = {
							["y"] = 0.09399651736021042,
							["x"] = 1.8799303770065308,
							["z"] = 0.09399651736021042
						},
					},
					["BreastTexture"] = {
						["Instance"] = "Mesh",
						["MeshId"] = "rbxassetid://7606070501",
						["Color"] = "Base",
						["Function"] = {},
						["Transparency"] = 1,
						["Name"] = "BreastTexture",
						["Parent"] = {
					
