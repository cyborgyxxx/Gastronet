;; Decentralized platform for chefs, recipes, and culinary expertise

;; Constants
(define-constant executive-chef tx-sender)
(define-constant err-chef-only (err u600))
(define-constant err-culinary-not-found (err u601))
(define-constant err-chef-already-exists (err u602))
(define-constant err-kitchen-violation (err u603))

;; Data Variables
(define-data-var next-chef-id uint u1)
(define-data-var next-recipe-id uint u1)

;; Data Maps
(define-map chefs
  { culinary-artist: principal }
  {
    chef-name: (string-ascii 50),
    cuisine-specialty: (string-ascii 80),
    culinary-background: (string-ascii 450),
    kitchen-debut: uint
  }
)

(define-map recipes
  { recipe-id: uint }
  {
    chef: principal,
    dish-name: (string-ascii 100),
    cuisine-type: (string-ascii 70),
    recipe-description: (string-ascii 400),
    master-approved: bool,
    approver: (optional principal),
    created-at: uint
  }
)

(define-map taste-reviews
  { reviewer: principal, reviewed-chef: principal, culinary-skill: (string-ascii 60) }
  {
    review-notes: (string-ascii 280),
    tasting-date: uint
  }
)

(define-map kitchen-collaborations
  { head-chef: principal, sous-chef: principal }
  { working-together: bool, collaboration-began: uint }
)

;; Public Functions

;; Register as a culinary artist
(define-public (register-chef (chef-name (string-ascii 50)) (cuisine-specialty (string-ascii 80)) (culinary-background (string-ascii 450)))
  (let ((culinary-artist tx-sender))
    (asserts! (is-none (map-get? chefs { culinary-artist: culinary-artist })) err-chef-already-exists)
    (map-set chefs
      { culinary-artist: culinary-artist }
      {
        chef-name: chef-name,
        cuisine-specialty: cuisine-specialty,
        culinary-background: culinary-background,
        kitchen-debut: block-height
      }
    )
    (ok true)
  )
)

;; Update chef profile
(define-public (update-chef-profile (chef-name (string-ascii 50)) (cuisine-specialty (string-ascii 80)) (culinary-background (string-ascii 450)))
  (let ((culinary-artist tx-sender))
    (asserts! (is-some (map-get? chefs { culinary-artist: culinary-artist })) err-culinary-not-found)
    (map-set chefs
      { culinary-artist: culinary-artist }
      {
        chef-name: chef-name,
        cuisine-specialty: cuisine-specialty,
        culinary-background: culinary-background,
        kitchen-debut: block-height
      }
    )
    (ok true)
  )
)

;; Submit signature recipe
(define-public (submit-recipe (dish-name (string-ascii 100)) (cuisine-type (string-ascii 70)) (recipe-description (string-ascii 400)))
  (let 
    (
      (recipe-id (var-get next-recipe-id))
      (chef tx-sender)
    )
    (asserts! (is-some (map-get? chefs { culinary-artist: chef })) err-culinary-not-found)
    (map-set recipes
      { recipe-id: recipe-id }
      {
        chef: chef,
        dish-name: dish-name,
        cuisine-type: cuisine-type,
        recipe-description: recipe-description,
        master-approved: false,
        approver: none,
        created-at: block-height
      }
    )
    (var-set next-recipe-id (+ recipe-id u1))
    (ok recipe-id)
  )
)

;; Approve recipe as master chef
(define-public (approve-recipe (recipe-id uint) (chef principal))
  (let 
    (
      (recipe (unwrap! (map-get? recipes { recipe-id: recipe-id }) err-culinary-not-found))
      (approver tx-sender)
    )
    (asserts! (is-eq (get chef recipe) chef) err-kitchen-violation)
    (map-set recipes
      { recipe-id: recipe-id }
      (merge recipe { 
        master-approved: true, 
        approver: (some approver) 
      })
    )
    (ok true)
  )
)

;; Review culinary skills
(define-public (review-culinary-skills (reviewed-chef principal) (culinary-skill (string-ascii 60)) (review-notes (string-ascii 280)))
  (let ((reviewer tx-sender))
    (asserts! (is-some (map-get? chefs { culinary-artist: reviewer })) err-culinary-not-found)
    (asserts! (is-some (map-get? chefs { culinary-artist: reviewed-chef })) err-culinary-not-found)
    (asserts! (not (is-eq reviewer reviewed-chef)) err-kitchen-violation)
    (map-set taste-reviews
      { reviewer: reviewer, reviewed-chef: reviewed-chef, culinary-skill: culinary-skill }
      {
        review-notes: review-notes,
        tasting-date: block-height
      }
    )
    (ok true)
  )
)

;; Start kitchen collaboration
(define-public (start-kitchen-collaboration (kitchen-partner principal))
  (let ((chef tx-sender))
    (asserts! (is-some (map-get? chefs { culinary-artist: chef })) err-culinary-not-found)
    (asserts! (is-some (map-get? chefs { culinary-artist: kitchen-partner })) err-culinary-not-found)
    (asserts! (not (is-eq chef kitchen-partner)) err-kitchen-violation)
    (map-set kitchen-collaborations
      { head-chef: chef, sous-chef: kitchen-partner }
      { working-together: true, collaboration-began: block-height }
    )
    (map-set kitchen-collaborations
      { head-chef: kitchen-partner, sous-chef: chef }
      { working-together: true, collaboration-began: block-height }
    )
    (ok true)
  )
)

;; Read-only Functions
(define-read-only (get-chef-profile (culinary-artist principal))
  (map-get? chefs { culinary-artist: culinary-artist })
)

(define-read-only (get-recipe-details (recipe-id uint))
  (map-get? recipes { recipe-id: recipe-id })
)

(define-read-only (are-kitchen-collaborating (head-chef principal) (sous-chef principal))
  (default-to false (get working-together (map-get? kitchen-collaborations { head-chef: head-chef, sous-chef: sous-chef })))
)

(define-read-only (get-taste-review (reviewer principal) (reviewed-chef principal) (culinary-skill (string-ascii 60)))
  (map-get? taste-reviews { reviewer: reviewer, reviewed-chef: reviewed-chef, culinary-skill: culinary-skill })
)

(define-read-only (is-recipe-approved (recipe-id uint))
  (match (map-get? recipes { recipe-id: recipe-id })
    recipe (get master-approved recipe)
    false
  )
)

(define-read-only (get-next-recipe-id)
  (var-get next-recipe-id)
)