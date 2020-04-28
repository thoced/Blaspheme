shader_type spatial;
uniform vec3 fallParam;



void vertex() {
// Input:2
	vec3 n_out2p0 = VERTEX;

// VectorUniform:8
	vec3 n_out8p0 = fallParam;

// VectorOp:10
	vec3 n_in10p1 = vec3(0.00000, 20.00000, 0.00000);
	vec3 n_out10p0 = n_out8p0 * n_in10p1;

// VectorOp:9
	vec3 n_out9p0 = n_out2p0 - n_out10p0;
	

// Output:0
	VERTEX = n_out9p0;

}

void fragment() {
// Color:2
	vec3 n_out2p0 = vec3(0.000000, 0.250000, 1.000000);
	float n_out2p1 = 1.000000;

// Output:0
	ALBEDO = n_out2p0;

}

void light() {
// Output:0

}
