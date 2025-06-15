#[compute]
#version 450

// Invocations in the (x, y, z) dimension.
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(rgba16f, set = 0, binding = 0) uniform image2D color_image;

// Our push constant.
// Must be aligned to 16 bytes, just like the push constant we passed from the script.
layout(push_constant, std430) uniform Params {
	vec2 raster_size;
	vec2 pad;
} params;

// From https://documents.blackmagicdesign.com/InformationNotes/DaVinci_Resolve_17_Wide_Gamut_Intermediate.pdf
float linear_to_davinci_intermediate(float val) {
	if (val <= 0.00262409) {
		return val * 10.44426855;
	} else {
		return (log2(val + 0.0075) + 7.0) * 0.07329248;
	}
}

// The code we want to execute in each invocation.
void main() {
	ivec2 uv = ivec2(gl_GlobalInvocationID.xy);
	ivec2 size = ivec2(params.raster_size);

	if (uv.x >= size.x || uv.y >= size.y) {
		return;
	}

	vec4 color = imageLoad(color_image, uv);

	color.rgb = vec3(
		linear_to_davinci_intermediate(color.r),
		linear_to_davinci_intermediate(color.g),
		linear_to_davinci_intermediate(color.b)
	);

	imageStore(color_image, uv, color);
}
