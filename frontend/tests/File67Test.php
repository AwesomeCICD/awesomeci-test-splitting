<?php
use PHPUnit\Framework\TestCase;
use Demo\File67;

class File67Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File67::add(2, 3));
    }
}
