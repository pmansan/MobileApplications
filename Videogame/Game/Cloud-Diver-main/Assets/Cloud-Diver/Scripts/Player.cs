using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{

    [Tooltip("Controls the max height of the player jumps")]
    public float jumpHeight = 3;      
    [Tooltip("How much gravity is multiplied when cancelling a jump")]
    public float jumpCancelMultiplier = 2;

    public Animator animator;

    public bool isGrounded = false;      //to check if the player is on the ground (/not in the air)
    public bool isDead = false;
    private Rigidbody2D rb;
    private bool isHoldingJump = false;

   
    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
        rb.velocity = new Vector2(0, 0);
    }

    // Update is called once per frame
    void Update()
    {

        if(Input.GetKeyDown(KeyCode.Space)){
            this.isHoldingJump = true;
        }

        if(Input.GetKeyUp(KeyCode.Space)){
            this.isHoldingJump = false;
            rb.gravityScale = this.jumpCancelMultiplier;
        }
        animator.SetBool("isGrounded", isGrounded);
        animator.SetBool("jumpPressed", this.isHoldingJump);

        if (transform.position.y < -10f){
            setDead();
        }
    }

    private void setDead(){
        animator.SetBool("isDead", true);
        rb.constraints = RigidbodyConstraints2D.FreezeAll;
        this.isDead = true;
    }

    public float getMaxReach(){
        return transform.position.y + this.jumpHeight;
    }

    private float calculateJumpVelocity(){
        return Mathf.Sqrt(-2 * Physics.gravity.y * this.jumpHeight);
    }

    //Updates player once every "fixedDeltaTime" (a very short time value)
    private void FixedUpdate()
    {
        if(this.isHoldingJump && this.isGrounded){
            rb.velocity = new Vector2(0, calculateJumpVelocity());
        }


    }

    private void OnCollisionEnter2D(Collision2D collision){
        if(collision.gameObject.tag == "Cloud")
        {
            // Players is only grounded is collision happens from below
            foreach(ContactPoint2D point in collision.contacts){
                if(point.normal == new Vector2(0f, 1f))
                {
                    this.isGrounded = true;
                    rb.gravityScale = 1;
                }
            }
        }
        if(collision.gameObject.tag == "FlyingObstacle")
        {
            setDead();
        }
    }

    private void OnCollisionExit2D(Collision2D collision){
     if(collision.gameObject.tag == "Cloud")
     {
        this.isGrounded = false;
     }
    }
 }