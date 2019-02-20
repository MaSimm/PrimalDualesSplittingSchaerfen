# PrimalDualesSplittingSchärfen
Eine Implementierung des variationellen primal-dualen Algorithmus zum scharf stellen von Schwarz Weiß Fotos in der Programmiersprache Julia

Aufrufen mit:
export JULIA_NUM_THREADS=8
julia src/run_script_perf.jl --i "exp_bilder/test_bild1_falt.png" --vr 3 --hr 3 --a 5.0 --it 15000
