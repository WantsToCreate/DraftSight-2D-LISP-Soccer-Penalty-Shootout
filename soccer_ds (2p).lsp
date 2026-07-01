;;; ============================================================
;;; SOCCER_DS.LSP - A Soccer Penalty Shootout Game for DraftSight
;;; 2-Player version: Player 1 = Green ball, Player 2 = Blue ball
;;; Command to start: SOCCER
;;; ============================================================
;;; HOW TO PLAY:
;;;   1. Load this file via LoadApplication
;;;   2. Type SOCCER at the command line and press Enter
;;;   3. Players take turns shooting - 5 rounds each
;;;   4. Enter a shot direction when prompted:
;;;        1=Far Left  2=Left  3=Center  4=Right  5=Far Right
;;;   5. The goalkeeper dives to a random position
;;;   6. If your shot does not match the keeper position, YOU SCORE!
;;;   7. After all rounds the player with more goals wins.
;;;
;;; NOTE: LISP only runs on DraftSight Professional and above.
;;; ============================================================


(defun C:SOCCER ( / score1 score2 keeper-pos shot-pos round
                    bx by k-target
                    shot-label keeper-label result-msg
                    current-player current-score ball-color )

  (setq score1 0)
  (setq score2 0)
  (setq round 1)
  (soccer-draw-pitch)
  (soccer-draw-scoreboard score1 score2)
  (command "._ZOOM" "_E")

  (textscr)
  (princ "\n=============================================")
  (princ "\n      DRAFTSIGHT SOCCER SHOOTOUT - 2P       ")
  (princ "\n=============================================")
  (princ "\n  Each player takes 5 penalty kicks!")
  (princ "\n  Player 1 = GREEN ball  |  Player 2 = BLUE ball")
  (princ "\n  Aim using numbers 1-5:")
  (princ "\n    1=Far Left  2=Left  3=Center  4=Right  5=Far Right")
  (princ "\n=============================================\n")

  ;; --- Round loop: each round both players shoot once ---
  (while (<= round 5)

    ;; ---- PLAYER 1 TURN ----
    (setq current-player 1)
    (setq ball-color "Green")

    (graphscr)
    (soccer-draw-pitch)
    (soccer-draw-scoreboard score1 score2)
  (command "._ZOOM" "_E")
    (setq bx 0.0  by 20.0)
    (command "._CIRCLE" (list bx by 0) 1.2)

    (textscr)
    (princ (strcat "\n--- ROUND " (itoa round) " of 5 ---"))
    (princ (strcat "\n  PLAYER 1 (Green)  |  P1: " (itoa score1) "  P2: " (itoa score2)))
    (princ "\n  Where do you shoot? (1=Far Left, 2=Left, 3=Center, 4=Right, 5=Far Right): ")
    (setq shot-pos (atoi (getstring)))
    (if (< shot-pos 1) (setq shot-pos 1))
    (if (> shot-pos 5) (setq shot-pos 5))

    (setq keeper-pos (1+ (rem (fix (* (getvar "MILLISECS") 0.007)) 5)))
    (setq k-target (* (- keeper-pos 3) 6.0))

    (graphscr)
    (soccer-draw-pitch-no-keeper)
    (soccer-draw-scoreboard score1 score2)
  (command "._ZOOM" "_E")
    (command "._CIRCLE" (list bx by 0) 1.2)
    (soccer-animate-ball-color bx by (* (- shot-pos 3) 6.0) 28.0 3)
    (soccer-draw-keeper k-target 30.5)
    (command "._REDRAW")

    (if (= shot-pos keeper-pos)
      (setq result-msg "SAVED! The keeper got it!")
      (progn
        (setq score1 (1+ score1))
        (setq result-msg "GOAL! Great shot!")
      )
    )

    (setq shot-label   (soccer-dir-label shot-pos))
    (setq keeper-label (soccer-dir-label keeper-pos))

    (textscr)
    (princ "\n  [ PLAYER 1 - Green Ball ]")
    (princ (strcat "\n  You shot:    " shot-label))
    (princ (strcat "\n  Keeper dove: " keeper-label))
    (princ (strcat "\n  >>> " result-msg " <<<"))
    (getstring "\n  Press Enter for Player 2...")

    ;; ---- PLAYER 2 TURN ----
    (setq current-player 2)

    (graphscr)
    (soccer-draw-pitch)
    (soccer-draw-scoreboard score1 score2)
  (command "._ZOOM" "_E")
    (setq bx 0.0  by 20.0)
    (command "._CIRCLE" (list bx by 0) 1.2)

    (textscr)
    (princ (strcat "\n--- ROUND " (itoa round) " of 5 ---"))
    (princ (strcat "\n  PLAYER 2 (Blue)   |  P1: " (itoa score1) "  P2: " (itoa score2)))
    (princ "\n  Where do you shoot? (1=Far Left, 2=Left, 3=Center, 4=Right, 5=Far Right): ")
    (setq shot-pos (atoi (getstring)))
    (if (< shot-pos 1) (setq shot-pos 1))
    (if (> shot-pos 5) (setq shot-pos 5))

    (setq keeper-pos (1+ (rem (fix (* (getvar "MILLISECS") 0.007)) 5)))
    (setq k-target (* (- keeper-pos 3) 6.0))

    (graphscr)
    (soccer-draw-pitch-no-keeper)
    (soccer-draw-scoreboard score1 score2)
  (command "._ZOOM" "_E")
    (command "._CIRCLE" (list bx by 0) 1.2)
    (soccer-animate-ball-color bx by (* (- shot-pos 3) 6.0) 28.0 5)
    (soccer-draw-keeper k-target 30.5)
    (command "._REDRAW")

    (if (= shot-pos keeper-pos)
      (setq result-msg "SAVED! The keeper got it!")
      (progn
        (setq score2 (1+ score2))
        (setq result-msg "GOAL! Great shot!")
      )
    )

    (setq shot-label   (soccer-dir-label shot-pos))
    (setq keeper-label (soccer-dir-label keeper-pos))

    (textscr)
    (princ "\n  [ PLAYER 2 - Blue Ball ]")
    (princ (strcat "\n  You shot:    " shot-label))
    (princ (strcat "\n  Keeper dove: " keeper-label))
    (princ (strcat "\n  >>> " result-msg " <<<"))
    (getstring "\n  Press Enter for next round...")

    (setq round (1+ round))
  )

  ;; ---- FINAL RESULT ----
  (graphscr)
  (soccer-draw-pitch)
  (soccer-draw-scoreboard score1 score2)
  (command "._ZOOM" "_E")

  (textscr)
  (princ "\n=============================================")
  (princ "\n              FINAL SCORE                   ")
  (princ (strcat "\n   Player 1 (Green): " (itoa score1) " goals"))
  (princ (strcat "\n   Player 2 (Blue):  " (itoa score2) " goals"))
  (cond
    ((> score1 score2) (princ "\n   *** PLAYER 1 WINS! Congratulations! ***"))
    ((> score2 score1) (princ "\n   *** PLAYER 2 WINS! Congratulations! ***"))
    (T                 (princ "\n   *** IT'S A DRAW! What a shootout! ***"))
  )
  (princ "\n=============================================\n")
  (princ)
)


;;; ============================================================
;;; Helper: return direction label string for a position 1-5
;;; ============================================================
(defun soccer-dir-label ( pos / )
  (cond ((= pos 1) "Far Left")
        ((= pos 2) "Left")
        ((= pos 3) "Center")
        ((= pos 4) "Right")
        (T         "Far Right"))
)


;;; ============================================================
;;; Animate ball with color index (3=Green, 5=Blue in AutoCAD/DS)
;;; ============================================================
(defun soccer-animate-ball-color ( x1 y1 x2 y2 col-idx / steps i xi yi )
  (setq steps 12)
  (setq i 1)
  (command "._COLOR" col-idx)
  (while (<= i steps)
    (setq xi (+ x1 (* (/ (float i) steps) (- x2 x1))))
    (setq yi (+ y1 (* (/ (float i) steps) (- y2 y1))))
    (command "._CIRCLE" (list xi yi 0) 1.0)
    (command "._REDRAW")
    (setq i (1+ i))
  )
  (command "._CIRCLE" (list x2 y2 0) 1.4)
  (command "._COLOR" "_BYLAYER")
  (princ)
)


;;; ============================================================
;;; Draw the on-screen scoreboard above the field
;;; P1 score on the left, P2 score on the right
;;; ============================================================
(defun soccer-draw-scoreboard ( p1 p2 / )
  ;; Scoreboard bar sits just above the goal crossbar (goal top = y 34)
  (command "._RECTANGLE" (list -16 34 0) (list 16 37 0))

  ;; Player 1 label and score (left side)
  (command "._COLOR" 3)
  (command "._TEXT" (list -15 35.2 0) 1.0 0 "P1:")
  (command "._TEXT" (list -11 35.2 0) 1.0 0 (itoa p1))
  (command "._COLOR" "_BYLAYER")

  ;; Divider
  (command "._LINE" (list 0 34 0) (list 0 37 0) "")

  ;; Player 2 label and score (right side)
  (command "._COLOR" 5)
  (command "._TEXT" (list 2 35.2 0) 1.0 0 "P2:")
  (command "._TEXT" (list 6 35.2 0) 1.0 0 (itoa p2))
  (command "._COLOR" "_BYLAYER")

  (princ)
)


(defun soccer-draw-pitch ( / )
  (soccer-draw-pitch-base)
  (soccer-draw-keeper 0.0 30.5)
  (princ)
)

(defun soccer-draw-pitch-no-keeper ( / )
  (soccer-draw-pitch-base)
  (princ)
)


;;; ============================================================
;;; Pitch base -- field markings + DraftSight logo
;;; Pitch IS the penalty box itself: x=-16 to 16, y=18 to 30.
;;; Logo placed inside the box, lower-left (x=-16 to -8, y=18 to 26),
;;; scaled and shifted via the composite transform in soccer-draw-ds-logo.
;;; ============================================================
(defun soccer-draw-pitch-base ( / )

  (command "._ERASE" "_ALL" "")

  ;; Goal
  (command "._LINE" (list -12 30 0) (list -12 34 0) "")
  (command "._LINE" (list  12 30 0) (list  12 34 0) "")
  (command "._LINE" (list -12 34 0) (list  12 34 0) "")

  ;; Penalty area
  (command "._RECTANGLE" (list -16 30 0) (list 16 18 0))

  ;; 6-yard box
  (command "._RECTANGLE" (list -7 30 0) (list 7 24 0))

  ;; Penalty spot
  (command "._CIRCLE" (list 0 18 0) 0.6)

  ;; Penalty arc (shrunk to ~half size so it doesn't dominate the screen)
  (command "._ARC" "_C" (list 0 18 0) (list -4.6 18 0) "_A" "180")

  ;; DraftSight logo on the left side of the pitch
  (soccer-draw-ds-logo)

  (princ)
)


;;; ============================================================
;;; DS:Arc helper -- CCW arc via Center / Start-point / Angle
;;; cx cy : center   r : radius   startDeg : start angle (deg)
;;; sweep : positive CCW sweep in degrees
;;; ============================================================
(defun DS:SoccerArc (cx cy r startDeg sweep / rad sx sy)
  (setq rad (/ (* startDeg pi) 180.0))
  (setq sx  (+ cx (* r (cos rad))))
  (setq sy  (+ cy (* r (sin rad))))
  (command "._ARC" "_C" (list cx cy 0) (list sx sy 0) "_A" sweep)
)


;;; ============================================================
;;; soccer-draw-ds-logo
;;;
;;; Draws the DraftSight icon (triangle + D shape) on the left
;;; side of the pitch.  Geometry comes directly from DS_Icon.lsp,
;;; scaled by 0.28 and centered at (-29, 9) in pitch coordinates.
;;;
;;; Scale 0.28 produces a logo ~17 x 18 units, fitting cleanly
;;; in the open left-side space (x=-40 to -16, y=0 to 18).
;;;
;;; Elements:
;;;   1. Triangle  -- closed PLINE, 3 pts (teal)
;;;   2. D outline -- closed PLINE, 35 pts (teal)
;;;   3. D staff   -- open PLINE, 4 pts (green)
;;;   4. D outer curve -- open PLINE, 174 pts (green)
;;;   5. D diagonal    -- LINE (green)
;;;   6. D arc         -- CCW arc (green)
;;; ============================================================
(defun soccer-draw-ds-logo ( / pts)

  ;; ----------------------------------------------------------------
  ;; 1. TRIANGLE -- closed polyline (teal)
  ;; ----------------------------------------------------------------
  (command "._PLINE"
    (list -11.7280 26.0085 0)
    (list -12.5104 18.4431 0)
    (list -8.1527 17.9915 0)
    "_C"
  )

  ;; ----------------------------------------------------------------
  ;; 2. D OUTLINE -- closed polyline, 35 vertices (teal)
  ;; ----------------------------------------------------------------
  (command "._PLINE"
    (list -10.5825 21.6933 0)
    (list -10.3557 21.6933 0)
    (list -10.1163 21.6178 0)
    (list -10.1289 20.9123 0)
    (list -10.1415 20.8997 0)
    (list -10.2675 20.9303 0)
    (list -10.4331 20.9303 0)
    (list -10.5231 20.8691 0)
    (list -10.5483 20.8079 0)
    (list -10.5357 20.6325 0)
    (list -10.3089 20.1745 0)
    (list -10.2585 20.0135 0)
    (list -10.2459 19.7232 0)
    (list -10.2963 19.5065 0)
    (list -10.4511 19.2018 0)
    (list -10.5825 19.0003 0)
    (list -10.8183 18.8556 0)
    (list -11.1387 18.7509 0)
    (list -11.4295 18.7509 0)
    (list -11.6185 18.7851 0)
    (list -11.6185 19.6207 0)
    (list -11.5933 19.6333 0)
    (list -11.4331 19.5802 0)
    (list -11.2927 19.5802 0)
    (list -11.1667 19.6414 0)
    (list -11.1388 19.7395 0)
    (list -11.1514 19.9150 0)
    (list -11.3638 20.3460 0)
    (list -11.4322 20.5979 0)
    (list -11.4448 20.8079 0)
    (list -11.3710 21.1175 0)
    (list -11.2423 21.3370 0)
    (list -11.0271 21.5350 0)
    (list -10.8021 21.6466 0)
    (list -10.5825 21.6933 0)
    "_C"
  )

  ;; ----------------------------------------------------------------
  ;; 3. D STAFF -- open polyline, 4 vertices (green)
  ;; ----------------------------------------------------------------
  (command "._PLINE"
    (list -13.7653 18.1051 0)
    (list -14.0476 18.0148 0)
    (list -15.8473 23.8559 0)
    (list -15.5649 23.9462 0)
    ""
  )

  ;; ----------------------------------------------------------------
  ;; 4. D OUTER CURVE -- open polyline, 174 points (green)
  ;;    Fed one point at a time via a while loop.
  ;; ----------------------------------------------------------------
  (setq pts (list
    (list -15.5649 23.9462 0)
    (list -15.5117 23.9621 0)
    (list -15.4583 23.9770 0)
    (list -15.4045 23.9909 0)
    (list -15.3506 24.0038 0)
    (list -15.2964 24.0158 0)
    (list -15.2420 24.0267 0)
    (list -15.1874 24.0368 0)
    (list -15.1326 24.0458 0)
    (list -15.0777 24.0537 0)
    (list -15.0226 24.0607 0)
    (list -14.9675 24.0667 0)
    (list -14.9122 24.0717 0)
    (list -14.8568 24.0757 0)
    (list -14.8015 24.0787 0)
    (list -14.7460 24.0806 0)
    (list -14.6905 24.0816 0)
    (list -14.6350 24.0816 0)
    (list -14.5795 24.0805 0)
    (list -14.5241 24.0785 0)
    (list -14.4686 24.0754 0)
    (list -14.4133 24.0713 0)
    (list -14.3581 24.0663 0)
    (list -14.3029 24.0602 0)
    (list -14.2478 24.0531 0)
    (list -14.1929 24.0450 0)
    (list -14.1382 24.0359 0)
    (list -14.0836 24.0259 0)
    (list -14.0292 24.0148 0)
    (list -13.9751 24.0028 0)
    (list -13.9211 23.9898 0)
    (list -13.8674 23.9757 0)
    (list -13.8139 23.9608 0)
    (list -13.7608 23.9448 0)
    (list -13.7080 23.9280 0)
    (list -13.6554 23.9101 0)
    (list -13.6032 23.8913 0)
    (list -13.5514 23.8716 0)
    (list -13.4998 23.8508 0)
    (list -13.4488 23.8292 0)
    (list -13.3980 23.8067 0)
    (list -13.3477 23.7832 0)
    (list -13.2979 23.7588 0)
    (list -13.2485 23.7335 0)
    (list -13.1996 23.7074 0)
    (list -13.1511 23.6804 0)
    (list -13.1031 23.6524 0)
    (list -13.0557 23.6236 0)
    (list -13.0088 23.5940 0)
    (list -12.9624 23.5634 0)
    (list -12.9166 23.5321 0)
    (list -12.8714 23.4999 0)
    (list -12.8267 23.4669 0)
    (list -12.7827 23.4332 0)
    (list -12.7394 23.3986 0)
    (list -12.6965 23.3633 0)
    (list -12.6544 23.3271 0)
    (list -12.6130 23.2902 0)
    (list -12.5722 23.2526 0)
    (list -12.5321 23.2142 0)
    (list -12.4927 23.1751 0)
    (list -12.4541 23.1354 0)
    (list -12.4161 23.0948 0)
    (list -12.3789 23.0537 0)
    (list -12.3425 23.0118 0)
    (list -12.3068 22.9693 0)
    (list -12.2719 22.9262 0)
    (list -12.2377 22.8824 0)
    (list -12.2044 22.8380 0)
    (list -12.1720 22.7930 0)
    (list -12.1403 22.7474 0)
    (list -12.1094 22.7013 0)
    (list -12.0794 22.6547 0)
    (list -12.0502 22.6074 0)
    (list -12.0220 22.5597 0)
    (list -11.9945 22.5114 0)
    (list -11.9680 22.4627 0)
    (list -11.9423 22.4135 0)
    (list -11.9176 22.3638 0)
    (list -11.8937 22.3137 0)
    (list -11.8708 22.2632 0)
    (list -11.8488 22.2122 0)
    (list -11.8277 22.1609 0)
    (list -11.8076 22.1092 0)
    (list -11.7884 22.0571 0)
    (list -11.7701 22.0047 0)
    (list -11.7528 21.9520 0)
    (list -11.7365 21.8990 0)
    (list -11.7211 21.8456 0)
    (list -11.7067 21.7920 0)
    (list -11.6933 21.7382 0)
    (list -11.6808 21.6841 0)
    (list -11.6694 21.6298 0)
    (list -11.6589 21.5753 0)
    (list -11.6494 21.5206 0)
    (list -11.6409 21.4658 0)
    (list -11.6335 21.4108 0)
    (list -11.6269 21.3557 0)
    (list -11.6214 21.3005 0)
    (list -11.6170 21.2451 0)
    (list -11.6134 21.1898 0)
    (list -11.6110 21.1343 0)
    (list -11.6095 21.0789 0)
    (list -11.6090 21.0234 0)
    (list -11.6096 20.9679 0)
    (list -11.6111 20.9124 0)
    (list -11.6137 20.8569 0)
    (list -11.6173 20.8016 0)
    (list -11.6219 20.7462 0)
    (list -11.6275 20.6910 0)
    (list -11.6340 20.6359 0)
    (list -11.6416 20.5809 0)
    (list -11.6501 20.5262 0)
    (list -11.6597 20.4715 0)
    (list -11.6703 20.4170 0)
    (list -11.6818 20.3627 0)
    (list -11.6944 20.3086 0)
    (list -11.7079 20.2548 0)
    (list -11.7224 20.2013 0)
    (list -11.7379 20.1479 0)
    (list -11.7542 20.0949 0)
    (list -11.7716 20.0422 0)
    (list -11.7899 19.9899 0)
    (list -11.8093 19.9378 0)
    (list -11.8294 19.8862 0)
    (list -11.8507 19.8348 0)
    (list -11.8727 19.7839 0)
    (list -11.8957 19.7334 0)
    (list -11.9197 19.6833 0)
    (list -11.9445 19.6337 0)
    (list -11.9702 19.5845 0)
    (list -11.9968 19.5359 0)
    (list -12.0243 19.4876 0)
    (list -12.0526 19.4399 0)
    (list -12.0819 19.3928 0)
    (list -12.1120 19.3461 0)
    (list -12.1429 19.3001 0)
    (list -12.1747 19.2545 0)
    (list -12.2072 19.2096 0)
    (list -12.2406 19.1652 0)
    (list -12.2748 19.1216 0)
    (list -12.3097 19.0785 0)
    (list -12.3455 19.0361 0)
    (list -12.3820 18.9942 0)
    (list -12.4193 18.9531 0)
    (list -12.4573 18.9126 0)
    (list -12.4960 18.8729 0)
    (list -12.5354 18.8339 0)
    (list -12.5756 18.7956 0)
    (list -12.6164 18.7580 0)
    (list -12.6580 18.7212 0)
    (list -12.7001 18.6851 0)
    (list -12.7430 18.6498 0)
    (list -12.7864 18.6153 0)
    (list -12.8305 18.5816 0)
    (list -12.8752 18.5487 0)
    (list -12.9205 18.5166 0)
    (list -12.9663 18.4853 0)
    (list -13.0127 18.4549 0)
    (list -13.0597 18.4253 0)
    (list -13.1071 18.3966 0)
    (list -13.1552 18.3687 0)
    (list -13.2037 18.3417 0)
    (list -13.2526 18.3156 0)
    (list -13.3021 18.2905 0)
    (list -13.3519 18.2662 0)
    (list -13.4023 18.2428 0)
    (list -13.4530 18.2203 0)
    (list -13.5041 18.1988 0)
    (list -13.5557 18.1782 0)
    (list -13.6076 18.1584 0)
    (list -13.6598 18.1397 0)
    (list -13.7124 18.1220 0)
    (list -13.7653 18.1051 0)
  ))
  (command "._PLINE" (car pts))
  (setq pts (cdr pts))
  (while pts
    (command (car pts))
    (setq pts (cdr pts))
  )
  (command "")

  ;; ----------------------------------------------------------------
  ;; 5. D INTERIOR DIAGONAL -- line (green)
  ;; ----------------------------------------------------------------
  (command "._LINE"
    (list -13.4644 19.6436 0)
    (list -14.4310 22.7879 0)
    ""
  )

  ;; ----------------------------------------------------------------
  ;; 6. D ARC -- CCW arc bridging the diagonal endpoints (green)
  ;;    center=(-34.2695, 6.9678)  radius=3.7854
  ;;    start=-57.8308 deg   CCW sweep=149.8372 deg
  ;; ----------------------------------------------------------------
  (DS:SoccerArc -14.3713 21.0855 1.7035 -57.8308 149.8372)

  (princ)
)


;;; ============================================================
;;; Draw goalkeeper at (kx, ky)
;;; ============================================================
(defun soccer-draw-keeper ( kx ky / )
  (command "._RECTANGLE"
    (list (- kx 1.0) (- ky 1.5) 0)
    (list (+ kx 1.0) (+ ky 1.5) 0)
  )
  (command "._CIRCLE" (list kx (+ ky 2.25) 0) 0.75)
  (command "._TEXT" (list (- kx 0.75) (- ky 2.75) 0) 1.0 0 "GK")
  (princ)
)

;;; End of SOCCER_DS.LSP
(princ "\nSOCCER_DS.LSP loaded. Type SOCCER to play!\n")
(princ)
