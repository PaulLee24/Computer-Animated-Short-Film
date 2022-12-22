#version 430 core
layout(triangles) in;
layout(triangle_strip, max_vertices = 20) out;

in VS_OUT {
    vec3 normal;
    //the position in model space , "gl_in.gl_Position" is the position passed from vertex shader, so it's in screen space beacuse it have alread multipled with M V P matrix.
    vec3 position;
    vec2 uv;
} gs_in[];

uniform float time;

out vec4 color;
out vec2 uu;

int v = 20;

void main()
{
    vec3 a = vec3(gl_in[0].gl_Position) - vec3(gl_in[1].gl_Position);
    vec3 b = vec3(gl_in[2].gl_Position) - vec3(gl_in[1].gl_Position);
    vec3 N = normalize(cross(a, b));


    vec4 P = gl_in[0].gl_Position;
    vec4 P1 = gl_in[1].gl_Position;
    vec4 P2 = gl_in[2].gl_Position;



    vec4 c1 = vec4(1,0,0,1);
    vec4 c2 = vec4(0,1,0,1);
    vec4 c3 = vec4(0,0,1,1);
    vec4 c4 = vec4(1,1,1,1);

    
    if(time<45){

        gl_Position = P-vec4(0,0,0.01,0);
        color = vec4(abs(cos(0.1*time))*vec3(0.5,0.2,0.1),0.7);
        uu = gs_in[0].uv;
        EmitVertex();
    
        gl_Position = P1-vec4(0,0,0.01,0);
        color = vec4(abs(sin(0.1*time))*vec3(0.2,0.5,0.3),0.7);
        uu = gs_in[1].uv;
        EmitVertex();

        gl_Position = P2-vec4(0,0,0.01,0);
        color = vec4(abs(cos(0.1*time)*sin(0.1*time))*vec3(0.3,0.6,0.5),0.7);
        uu = gs_in[2].uv;
        EmitVertex();

    
        gl_Position = vec4(P+0.16*vec4(N,0));
        color = vec4(0.5,0.5,0.5,1);
        uu = gs_in[0].uv;
        EmitVertex();
    

        EndPrimitive();
    }
    
    float len = sqrt(P.x*P.x + P.z*P.z);
    float scale = abs(0.1 - 0.1 * tan(0.03*time + len));

    P = (P+vec4((N * scale) , 0.0));
    P1= (P1+vec4((N * scale) , 0.0));
    P2 = (P2+vec4((N * scale) , 0.0));

    if(time<30){

        gl_Position = P;
        color = abs(cos(0.01*time))*c4+(1-abs(cos(0.02*time)))*c3+time/30*c1;
        uu = gs_in[0].uv;
        EmitVertex();
    
        gl_Position = P1;
        color = abs(cos(0.07*time))*c1+(1-abs(cos(0.06*time)))*c4+time/30*c1;
        uu = gs_in[1].uv;
        EmitVertex();

        gl_Position = P2;
        color = abs(cos(0.04*time))*c2+(1-abs(cos(0.03*time)))*c3+time/30*c1;
        uu = gs_in[2].uv;
        EmitVertex();
    
    }
	
	int start;

    if(time>=30&&time<40){
        start = 30;
		
		gl_Position = P+vec4(3*(time-start)*N.x,3*(time-start)*N.y-1*(time-start)*(time-start),3*(time-start)*N.z,0);
        color = abs(cos(0.01*time))*c4+(1-abs(cos(0.02*time)))*c3+(60-time)/10*c1;
        uu = gs_in[0].uv;
        EmitVertex();
    
        gl_Position = P1+vec4(3*(time-start)*N.x,3*(time-start)*N.y-1*(time-start)*(time-start),3*(time-start)*N.z,0);
        color = abs(cos(0.07*time))*c1+(1-abs(cos(0.06*time)))*c4+(60-time)/10*c1;
        uu = gs_in[1].uv;
        EmitVertex();

        gl_Position = P2+vec4(3*(time-start)*N.x,3*(time-start)*N.y-1*(time-start)*(time-start),3*(time-start)*N.z,0);
        color = abs(cos(0.04*time))*c2+(1-abs(cos(0.03*time)))*c3+(50-time)/10*c1;
        uu = gs_in[2].uv;
        EmitVertex();
    }
	
	P = gl_in[0].gl_Position;
    P1 = gl_in[1].gl_Position;
    P2 = gl_in[2].gl_Position;

    if(time>45 && time<55){
        start = 45;

        gl_Position = (P+P1+P2)/3+vec4(N,0)/2+vec4(b,0)+vec4(2*(time-start)*N.x,3*(time-start)*N.y-0.2*(time-start)*(time-start),(time-start)*N.z,0);
        color = vec4(1,1,1,0.3);
        uu = gs_in[0].uv;
        EmitVertex();
    
        gl_Position = (P+P1+P2)/3+vec4(N,0)/2-vec4(a-b,0)+vec4(2*(time-start)*N.x,3*(time-start)*N.y-0.2*(time-start)*(time-start),(time-start)*N.z,0);
        color = vec4(0,0,0.5,0.3);
        uu = gs_in[1].uv;
        EmitVertex();

        gl_Position = (P+P1+P2)/3+vec4(N,0)/2+vec4(a,0)+vec4(2*(time-start)*N.x,3*(time-start)*N.y-0.2*(time-start)*(time-start),(time-start)*N.z,0);
        color = vec4(0,0.5,0,0.3);
        uu = gs_in[2].uv;
        EmitVertex();

        EndPrimitive();

        gl_Position = P-vec4(0,0,0.01,0)+vec4(2*(time-start)*N.x,2*(time-start)*N.y-0.5*(time-start)*(time-start),2*(time-start)*N.z,0);
        color = vec4(abs(cos(0.1*time))*vec3(0.5,0.2,0.1),0.7);
        uu = gs_in[0].uv;
        EmitVertex();
    
        gl_Position = P1-vec4(0,0,0.01,0)+vec4(2*(time-start)*N.x,2*(time-start)*N.y-0.5*(time-start)*(time-start),2*(time-start)*N.z,0);
        color = vec4(abs(sin(0.1*time))*vec3(0.2,0.5,0.3),0.7);
        uu = gs_in[1].uv;
        EmitVertex();

        gl_Position = P2-vec4(0,0,0.01,0)+vec4(2*(time-start)*N.x,2*(time-start)*N.y-0.5*(time-start)*(time-start),2*(time-start)*N.z,0);
        color = vec4(abs(cos(0.1*time)*sin(0.1*time))*vec3(0.3,0.6,0.5),0.7);
        uu = gs_in[2].uv;
        EmitVertex();

    
        gl_Position = vec4(P+0.16*vec4(N,0))+vec4(2*(time-start)*N.x,2*(time-start)*N.y-0.5*(time-start)*(time-start),2*(time-start)*N.z,0);
        color = vec4(0.5,0.5,0.5,1);
        uu = gs_in[0].uv;
        EmitVertex();    
    }

    if(time>55 && time<65){
        int r_start = 55;
		int ex_start = 45;

        gl_Position = (P+P1+P2)/3+vec4(N,0)/2+vec4(b,0)+vec4(2*(r_start-ex_start)*N.x,3*(r_start-ex_start)*N.y-0.2*(r_start-ex_start)*(r_start-ex_start),(r_start-ex_start)*N.z,0);
        color = vec4(1,1,1,0.3);
        uu = gs_in[0].uv;
        EmitVertex();
    
        gl_Position = (P+P1+P2)/3+vec4(N,0)/2-vec4(a-b,0)+vec4(2*(r_start-ex_start)*N.x,3*(r_start-ex_start)*N.y-0.2*(r_start-ex_start)*(r_start-ex_start),(r_start-ex_start)*N.z,0);
        color = vec4(0,0,0.5,0.3);
        uu = gs_in[1].uv;
        EmitVertex();

        gl_Position = (P+P1+P2)/3+vec4(N,0)/2+vec4(a,0)+vec4(2*(r_start-ex_start)*N.x,3*(r_start-ex_start)*N.y-0.2*(r_start-ex_start)*(r_start-ex_start),(r_start-ex_start)*N.z,0);
        color = vec4(0,0.5,0,0.3);
        uu = gs_in[2].uv;
        EmitVertex();

        EndPrimitive();

        gl_Position = P-vec4(0,0,0.01,0)+vec4(2*(r_start-ex_start)*N.x,2*(r_start-ex_start)*N.y-0.5*(r_start-ex_start)*(r_start-ex_start),2*(r_start-ex_start)*N.z,0);
        color = vec4(abs(cos(0.1*r_start))*vec3(0.5,0.2,0.1),0.7);
        uu = gs_in[0].uv;
        EmitVertex();
    
        gl_Position = P1-vec4(0,0,0.01,0)+vec4(2*(r_start-ex_start)*N.x,2*(r_start-ex_start)*N.y-0.5*(r_start-ex_start)*(r_start-ex_start),2*(r_start-ex_start)*N.z,0);
        color = vec4(abs(sin(0.1*r_start))*vec3(0.2,0.5,0.3),0.7);
        uu = gs_in[1].uv;
        EmitVertex();

        gl_Position = P2-vec4(0,0,0.01,0)+vec4(2*(r_start-ex_start)*N.x,2*(r_start-ex_start)*N.y-0.5*(r_start-ex_start)*(r_start-ex_start),2*(r_start-ex_start)*N.z,0);
        color = vec4(abs(cos(0.1*r_start)*sin(0.1*r_start))*vec3(0.3,0.6,0.5),0.7);
        uu = gs_in[2].uv;
        EmitVertex();

    
        gl_Position = vec4(P+0.16*vec4(N,0))+vec4(2*(r_start-ex_start)*N.x,2*(r_start-ex_start)*N.y-0.5*(r_start-ex_start)*(r_start-ex_start),2*(r_start-ex_start)*N.z,0);
        color = vec4(0.5,0.5,0.5,1);
        uu = gs_in[0].uv;
        EmitVertex();    
    }

    if(time>=65 && time<75){
        int end_time = 75;

        gl_Position = (P+P1+P2)/3+vec4(N,0)/2+vec4(b,0)+vec4(2*(end_time-time)*N.x,3*(end_time-time)*N.y-0.2*(end_time-time)*(end_time-time),(end_time-time)*N.z,0);
        color = vec4(1,1,1,0.3);
        uu = gs_in[0].uv;
        EmitVertex();
    
        gl_Position = (P+P1+P2)/3+vec4(N,0)/2-vec4(a-b,0)+vec4(2*(end_time-time)*N.x,3*(end_time-time)*N.y-0.2*(end_time-time)*(end_time-time),(end_time-time)*N.z,0);
        color = vec4(0,0,0.5,0.3);
        uu = gs_in[1].uv;
        EmitVertex();

        gl_Position = (P+P1+P2)/3+vec4(N,0)/2+vec4(a,0)+vec4(2*(end_time-time)*N.x,3*(end_time-time)*N.y-0.2*(end_time-time)*(end_time-time),(end_time-time)*N.z,0);
        color = vec4(0,0.5,0,0.3);
        uu = gs_in[2].uv;
        EmitVertex();

        EndPrimitive();

        gl_Position = P-vec4(0,0,0.01,0)+vec4(2*(end_time-time)*N.x,2*(end_time-time)*N.y-0.5*(end_time-time)*(end_time-time),2*(end_time-time)*N.z,0);
        color = vec4(abs(cos(0.1*end_time))*vec3(0.5,0.2,0.1),0.7);
        uu = gs_in[0].uv;
        EmitVertex();
    
        gl_Position = P1-vec4(0,0,0.01,0)+vec4(2*(end_time-time)*N.x,2*(end_time-time)*N.y-0.5*(end_time-time)*(end_time-time),2*(end_time-time)*N.z,0);
        color = vec4(abs(sin(0.1*end_time))*vec3(0.2,0.5,0.3),0.7);
        uu = gs_in[1].uv;
        EmitVertex();

        gl_Position = P2-vec4(0,0,0.01,0)+vec4(2*(end_time-time)*N.x,2*(end_time-time)*N.y-0.5*(end_time-time)*(end_time-time),2*(end_time-time)*N.z,0);
        color = vec4(abs(cos(0.1*end_time)*sin(0.1*end_time))*vec3(0.3,0.6,0.5),0.7);
        uu = gs_in[2].uv;
        EmitVertex();

    
        gl_Position = vec4(P+0.16*vec4(N,0))+vec4(2*(end_time-time)*N.x,2*(end_time-time)*N.y-0.5*(end_time-time)*(end_time-time),2*(end_time-time)*N.z,0);
        color = vec4(0.5,0.5,0.5,1);
        uu = gs_in[0].uv;
        EmitVertex(); 
    }

    

    if(time>75 && time<103){
        gl_Position = P-vec4(0,0,0.01,0);
        color = vec4(abs(cos(0.1*time))*vec3(0.5,0.2,0.1),0.7);
        uu = gs_in[0].uv;
        EmitVertex();
    
        gl_Position = P1-vec4(0,0,0.01,0);
        color = vec4(abs(sin(0.1*time))*vec3(0.2,0.5,0.3),0.7);
        uu = gs_in[1].uv;
        EmitVertex();

        gl_Position = P2-vec4(0,0,0.01,0);
        color = vec4(abs(cos(0.1*time)*sin(0.1*time))*vec3(0.3,0.6,0.5),0.7);
        uu = gs_in[2].uv;
        EmitVertex();

    
        gl_Position = vec4(P+0.16*vec4(N,0));
        color = vec4(0.5,0.5,0.5,1);
        uu = gs_in[0].uv;
        EmitVertex();
    

        EndPrimitive();
    }

    if(time>103){
        int t_start = 103;

        gl_Position = (P+P1+P2)/3+vec4(N,0)/2+vec4(b,0)+vec4(2*(time-t_start)*N.x,3*(time-t_start)*N.y-0.2*(time-t_start)*(time-t_start),(time-t_start)*N.z,0);
        color = vec4(1,1,1,0.3);
        uu = gs_in[0].uv;
        EmitVertex();
    
        gl_Position = (P+P1+P2)/3+vec4(N,0)/2-vec4(a-b,0)+vec4(2*(time-t_start)*N.x,3*(time-t_start)*N.y-0.2*(time-t_start)*(time-t_start),(time-t_start)*N.z,0);
        color = vec4(0,0,0.5,0.3);
        uu = gs_in[1].uv;
        EmitVertex();

        gl_Position = (P+P1+P2)/3+vec4(N,0)/2+vec4(a,0)+vec4(2*(time-t_start)*N.x,3*(time-t_start)*N.y-0.2*(time-t_start)*(time-t_start),(time-t_start)*N.z,0);
        color = vec4(0,0.5,0,0.3);
        uu = gs_in[2].uv;
        EmitVertex();

        EndPrimitive();

        gl_Position = P-vec4(0,0,0.01,0)+vec4(2*(time-t_start)*N.x,2*(time-t_start)*N.y-0.5*(time-t_start)*(time-t_start),2*(time-t_start)*N.z,0);
        color = vec4(abs(cos(0.1*time))*vec3(0.5,0.2,0.1),0.7);
        uu = gs_in[0].uv;
        EmitVertex();
    
        gl_Position = P1-vec4(0,0,0.01,0)+vec4(2*(time-t_start)*N.x,2*(time-t_start)*N.y-0.5*(time-t_start)*(time-t_start),2*(time-t_start)*N.z,0);
        color = vec4(abs(sin(0.1*time))*vec3(0.2,0.5,0.3),0.7);
        uu = gs_in[1].uv;
        EmitVertex();

        gl_Position = P2-vec4(0,0,0.01,0)+vec4(2*(time-t_start)*N.x,2*(time-t_start)*N.y-0.5*(time-t_start)*(time-t_start),2*(time-t_start)*N.z,0);
        color = vec4(abs(cos(0.1*time)*sin(0.1*time))*vec3(0.3,0.6,0.5),0.7);
        uu = gs_in[2].uv;
        EmitVertex();

    
        gl_Position = vec4(P+0.16*vec4(N,0))+vec4(2*(time-t_start)*N.x,2*(time-t_start)*N.y-0.5*(time-t_start)*(time-t_start),2*(time-t_start)*N.z,0);
        color = vec4(0.5,0.5,0.5,1);
        uu = gs_in[0].uv;
        EmitVertex();    
    }
    

    EndPrimitive();
}
